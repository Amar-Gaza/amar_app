import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../app/routes/route_args.dart';
import '../../core/constants/api_query.dart';
import '../../core/constants/storage_keys.dart';
import '../../core/network/ai_gateway_client.dart';
import '../../core/storage/app_preferences.dart';
import '../../data/models/ai/ai_chat_form.dart';
import '../../data/models/ai/ai_chat_message.dart';
import '../../data/models/ai/ai_intent.dart';
import '../../data/models/ai/ai_order_draft.dart';
import '../../data/models/cart/cart_item.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/address_service.dart';
import '../../data/services/customer/catalog_service.dart';
import '../../data/services/shared/ai_speech_service.dart';
import '../shared/app_config_controller.dart';
import '../shared/session_controller.dart';
import 'ai_action_executor.dart';
import 'ai_address_command.dart';
import '../../presentation/screens/ai/ai_address_selection_screen.dart';
import 'ai_guided_checkout.dart';
import 'ai_task_controller.dart';

/// ChatGPT-style chat with app-owned, API-backed forms and a resumable draft.
/// Gemini can converse/search, but it cannot invent product IDs or authorize
/// cart changes, order submission, payments, permissions or login actions.
class AiChatController extends GetxController {
  AiChatController(this._gateway, this._prefs, this._session, this._executor, this._speech);

  final AiGatewayClient _gateway;
  final AppPreferences _prefs;
  final SessionController _session;
  final AiActionExecutor _executor;
  final AiSpeechService _speech;

  final input = TextEditingController();
  final messages = <AiChatMessage>[].obs;
  final isSending = false.obs;
  final isListening = false.obs;
  final voiceReplies = false.obs;
  final chatLanguage = 'ar'.obs;
  final isNavigatingAddress = false.obs;
  final isPreparingOrder = false.obs;
  final isSubmittingForm = false.obs;
  final errorCode = RxnString();
  final orderProgress = ''.obs;

  AiOrderDraft? _draft;
  int? _chosenAddressId;
  String? _chosenAddressLabel;
  int? _customerId;
  bool _voiceSubmitted = false;
  int _formSeq = 0;
  Future<void> _lastSave = Future<void>.value();
  final Map<int, String> _vendorNames = {};

  bool get _ar => chatLanguage.value != 'en';
  String _tr(String ar, String en) => _ar ? ar : en;

  void setChatLanguage(String language) {
    if (language != 'ar' && language != 'en') return;
    chatLanguage.value = language;
    unawaited(_speech.stopSpeaking());
    unawaited(_save());
  }


  AiChatForm? get pendingForm {
    final draft = _draft;
    if (draft == null || draft.stage == AiDraftStage.finished) return null;
    for (final msg in messages.reversed) {
      if (msg.form != null && !msg.formAnswered &&
          msg.form!.purpose == draft.stage) return msg.form;
    }
    return null;
  }

  bool isFormActive(String id) => pendingForm?.id == id;

  List<AiCatalogItem> get lastResults {
    for (final message in messages.reversed) {
      if (!message.isUser && message.results.isNotEmpty) return message.results;
    }
    return const [];
  }

  @override
  void onInit() {
    super.onInit();
    chatLanguage.value = Get.locale?.languageCode == 'en' ? 'en' : 'ar';
    _customerId = _session.user.value?.id;
    if (_customerId == null) return;
    final snapshot = _prefs.customerState(StorageKeys.customerAiChat, customerId: _customerId);
    if (snapshot == null) return;
    final storedLang = snapshot['chat_language'];
    if (storedLang == 'ar' || storedLang == 'en') {
      chatLanguage.value = storedLang as String;
    }
    voiceReplies.value = snapshot['voice_replies'] == true;
    final storedAddressId = snapshot['selected_address_id'];
    if (storedAddressId is int && storedAddressId > 0) {
      _chosenAddressId = storedAddressId;
      _chosenAddressLabel = snapshot['selected_address_label'] as String?;
    }
    final restored = <AiChatMessage>[];
    final raw = snapshot['messages'];
    if (raw is List) {
      for (final item in raw.skip(raw.length > 60 ? raw.length - 60 : 0)) {
        if (item is! Map) continue;
        try { restored.add(AiChatMessage.fromJson(Map<String, dynamic>.from(item))); }
        catch (_) { /* Ignore a single corrupt saved message. */ }
      }
    }
    // A saved V8 form could still contain placeholder names like
    // "المتجر رقم 43". Disable it and regenerate using verified names.
    for (var i = 0; i < restored.length; i++) {
      final message = restored[i];
      final form = message.form;
      if (form != null && form.purpose == AiDraftStage.vendor &&
          form.fields.any((field) => field.choices.any(
              (choice) => _realVendorName(choice.label).isEmpty))) {
        restored[i] = message.copyWith(formAnswered: true);
      }
    }
    messages.assignAll(restored);
    if (snapshot['draft'] is Map) {
      try {
        final candidate = AiOrderDraft.fromJson(Map<String, dynamic>.from(snapshot['draft'] as Map));
        if (candidate.candidates.isNotEmpty && candidate.quantity >= 1 && candidate.quantity <= 20) {
          _draft = candidate;
          _vendorNames.addAll(candidate.vendorNames);
        }
      } catch (_) { _draft = null; }
    }
  }

  Future<void> _save() {
    final id = _customerId;
    if (id == null) return Future<void>.value();
    // Snapshot now, serialize disk writes. A slower previous write must not
    // overwrite newer answers when several messages are appended quickly.
    final last = messages.length > 60
        ? messages.skip(messages.length - 60).toList() : messages.toList();
    final snapshot = <String, dynamic>{
      'schema': 5,
      'messages': last.map((m) => m.toJson()).toList(),
      'draft': _draft?.toJson(),
      'selected_address_id': _chosenAddressId,
      'selected_address_label': _chosenAddressLabel,
      'chat_language': chatLanguage.value,
      'voice_replies': voiceReplies.value,
    };
    final frozen = Map<String, dynamic>.from(jsonDecode(jsonEncode(snapshot)) as Map);
    _lastSave = _lastSave.then((_) => _prefs.saveCustomerState(
      StorageKeys.customerAiChat, frozen, customerId: id,
    )).catchError((Object _) { /* Local cache failure is non-fatal. */ });
    return _lastSave;
  }

  @override
  void onReady() {
    super.onReady();
    if (_draft != null && pendingForm == null &&
        _draft!.stage != AiDraftStage.finished) {
      unawaited(resumeDraft());
    }
  }

  /// Rebuilds an interrupted step after app recreation. Old product and
  /// payment details will still be rechecked against the server.
  Future<void> resumeDraft() async {
    final d = _draft;
    if (d == null || pendingForm != null) return;
    try {
      if (!await _resolveVendorNames(d)) {
        _assistant('تعذر التحقق من أسماء الشركات السابقة. ابحث عن المنتج مجدداً لتحديث البيانات.');
        return;
      }
      switch (d.stage) {
        case AiDraftStage.vendor:
          _promptVendor();
          break;
        case AiDraftStage.product:
          _promptProduct();
          break;
        case AiDraftStage.options:
          if (d.productId != null) {
            await _promptOptions(await Get.find<CatalogService>().product(d.productId!));
          }
          break;
        case AiDraftStage.address:
          await _promptAddress();
          break;
        case AiDraftStage.payment:
          await _promptPayment();
          break;
        case AiDraftStage.review:
          _promptReview();
          break;
      }
      await _save();
    } catch (_) {
      _assistant('واجهنا مشكلة باستكمال الخطوة السابقة. جرّب إرسال طلبك من جديد.');
    }
  }

  void _assistant(String text, {AiChatForm? form}) {
    messages.add(AiChatMessage(
      role: 'assistant', text: text, createdAt: DateTime.now(), form: form,
    ));
    unawaited(_save());
    if (voiceReplies.value) unawaited(speakMessage(text));
  }

  void _addForm({required String stage, required String title,
      required List<AiFormField> fields, String? help,
      String submit = 'متابعة'}) {
    final draft = _draft;
    if (draft == null) return;
    draft.stage = stage;
    _formSeq++;
    final form = AiChatForm(
      id: '${DateTime.now().microsecondsSinceEpoch}_$_formSeq',
      purpose: stage, title: title, fields: fields,
      help: help, submitLabel: submit,
    );
    _assistant(_tr('حدّد الخيارات التالية وبكمل معك نفس الطلب:',
      'Choose an option below to continue your order:') + '\n' + title, form: form);
  }

  /// Normal open-ended chat is still handled by the authenticated gateway.
  /// Existing forms remain visible while the user asks unrelated questions.
  Future<void> send([String? provided]) async {
    final text = (provided ?? input.text).trim();
    if (text.isEmpty || isSending.value || isPreparingOrder.value ||
        isSubmittingForm.value || isNavigatingAddress.value) return;
    if (text.length > 2000) { errorCode.value = 'message_too_long'; return; }

    // Address navigation is a LOCAL, user-requested action. It must never
    // depend on Gemini hallucinating a route or saving anything itself.
    final addressCommand = parseAiAddressCommand(text);
    if (addressCommand != null) {
      if (isListening.value) {
        isListening.value = false;
        await _speech.stopListening();
      }
      await _speech.stopSpeaking();
      input.clear();
      messages.add(AiChatMessage(role: 'user', text: text,
        createdAt: DateTime.now()));
      await _save();
      await openAddressFlow(addressCommand);
      return;
    }

    if (await _answerPendingFromText(text)) {
      input.clear();
      return;
    }

    isSending.value = true;
    errorCode.value = null;
    try {
      if (isListening.value) {
        isListening.value = false;
        await _speech.stopListening();
      }
      await _speech.stopSpeaking();
      input.clear();

      final history = messages.reversed.take(12).toList().reversed.map((m) => {
        'role': m.role,
        'text': m.text.length > 450 ? m.text.substring(0, 450) : m.text,
      }).toList();
      final previous = lastResults;

      messages.add(AiChatMessage(role: 'user', text: text, createdAt: DateTime.now()));
      await _save();
      final pending = pendingForm;
      final draftContext = _draft;
      final reply = await _gateway.chat(
        message: text, locale: chatLanguage.value,
        history: history, lastResults: previous,
        pendingForm: pending == null || draftContext == null ? null : {
          'stage': draftContext.stage,
          'question': pending.title,
          'product': draftContext.selectedItem?.name ?? '',
          'options': [
            for (final field in pending.fields.take(4))
              {
                'label': field.label,
                'choices': field.choices.take(8).map((c) => c.label).toList(),
              },
          ],
        },
      );
      // The raw result is displayed and saved as an ordinary assistant reply.
      // The V8 form below is generated ONLY from the verified result records.
      messages.add(AiChatMessage(
        role: 'assistant', text: reply.reply, createdAt: DateTime.now(),
        results: reply.results, suggestions: reply.suggestions,
        canPrepareOrder: reply.action == 'search_catalog',
      ));
      await _save();

      if (voiceReplies.value) {
        if (!await _speech.speak(reply.reply,
            language: aiSpeechLanguageFor(reply.reply, fallback: chatLanguage.value))) {
          errorCode.value = 'speech_voice_missing';
        }
      }

      if (reply.action == 'prepare_order') {
        await _beginDraft(reply.query, reply.results, reply.quantity);
      } else {
        _executor.run(reply);
      }
    } on AiGatewayException catch (e) {
      errorCode.value = e.code;
    } catch (_) {
      errorCode.value = 'network_error';
    } finally {
      isSending.value = false;
    }
  }

  /// Older stored V7 buttons also enter the safe V8 preflight, rather than
  /// skipping the customer's company / quantity / options / address questions.
  Future<void> prepareOrder(AiCatalogItem item, int qty) async {
    await _beginDraft(item.name, [item], qty);
  }

  Future<void> _beginDraft(String query, List<AiCatalogItem> results, int qty) async {
    if (Get.isRegistered<AiTaskController>() && Get.find<AiTaskController>().busy) {
      _assistant('في مهمة طلب شغالة. أوقفها أو خلّص مراجعتها أولاً.');
      return;
    }
    for (var i = 0; i < messages.length; i++) {
      final msg = messages[i];
      if (msg.form != null && !msg.formAnswered) {
        messages[i] = msg.copyWith(formAnswered: true);
      }
    }
    final eligible = results.where((r) =>
        const {'product', 'service'}.contains(r.type) &&
        r.vendorId != null && r.vendorId! > 0).take(8).toList();
    if (eligible.isEmpty) {
      _draft = null;
      _assistant('ما لقيت منتجاً قابلاً للطلب ضمن النتائج المؤكدة. جرّب اسم أدق أو ابحث في الأقسام.');
      return;
    }
    _draft = AiOrderDraft(
      query: query, candidates: eligible,
      quantity: qty >= 1 && qty <= 20 ? qty : 1,
    );
    _vendorNames.clear();
    final vendorIds = eligible.map((item) => item.vendorId!).toSet();
    final resolved = await _resolveVendorNames(_draft!);
    if (!resolved) {
      _draft = null;
      _assistant(
        'ما قدرت أتحقق من أسماء كل الشركات الموجودة ضمن النتائج. '
        'جرّب إعادة البحث؛ مش رح أعرض لك أرقام متاجر بدل الأسماء.',
      );
      await _save();
      return;
    }
    if (vendorIds.length > 1) {
      _promptVendor();
    } else {
      _draft!.vendorId = vendorIds.first;
      _promptProduct();
    }
    await _save();
  }

  /// Names must come from verified Masar records; never display numeric
  /// placeholders. Also cleans legacy V8 drafts saved before this fix.
  String _realVendorName(String value) {
    final name = value.trim();
    if (name.isEmpty ||
        RegExp(r'^(?:المتجر|الشركة|شركه|متجر|vendor|shop)\s*(?:رقم|#)?\s*\d+$',
                caseSensitive: false).hasMatch(name)) {
      return '';
    }
    return name;
  }

  Future<bool> _resolveVendorNames(AiOrderDraft draft) async {
    final ids = draft.candidates
        .map((item) => item.vendorId)
        .whereType<int>()
        .where((id) => id > 0)
        .toSet();
    _vendorNames.clear();
    await Future.wait(ids.map((id) async {
      String name = '';
      for (final item in draft.candidates) {
        if (item.vendorId != id) continue;
        name = _realVendorName(item.vendorName);
        if (name.isNotEmpty) break;
      }
      // Fallback is a real vendor API lookup, never a fake store label.
      if (name.isEmpty) {
        try {
          final vendor = await Get.find<CatalogService>()
              .vendor(id).timeout(const Duration(seconds: 8));
          name = _realVendorName(vendor.name);
        } catch (_) {
          name = '';
        }
      }
      if (name.isNotEmpty) {
        _vendorNames[id] = name;
        draft.vendorNames[id] = name;
      } else {
        draft.vendorNames.remove(id);
      }
    }));
    return ids.isNotEmpty && ids.every(_vendorNames.containsKey);
  }

  void _promptVendor() {
    final draft = _draft!;
    final vendorIds = draft.candidates.map((e) => e.vendorId).whereType<int>().toSet();
    _addForm(
      stage: AiDraftStage.vendor,
      title: _tr('من أي شركة أو متجر بدك تشتري؟', 'Which store would you like to order from?'),
      fields: [AiFormField(
        key: 'vendor', label: _tr('الشركة / المتجر', 'Store / Vendor'), type: AiFormType.single,
        choices: vendorIds.map((id) => AiFormChoice(
          value: '$id', label: _vendorNames[id]!,
          detail: _tr(
            '${draft.candidates.where((item) => item.vendorId == id).length} منتج ضمن النتائج',
            '${draft.candidates.where((item) => item.vendorId == id).length} matching items'),
        )).toList(),
      )],
      help: _tr('هاي الشركات مرتبطة بمنتجات حقيقية رجّعها السيرفر.',
        'These stores are verified against actual catalog records.'),
    );
  }

  void _promptProduct() {
    final draft = _draft!;
    final products = draft.candidates.where((p) => p.vendorId == draft.vendorId).toList();
    if (products.isEmpty) { _assistant('ما في منتجات متوفرة ضمن المتجر المختار.'); return; }
    _addForm(
      stage: AiDraftStage.product,
      title: _tr('اختار المنتج والعدد المطلوب', 'Select the product and quantity'),
      fields: [
        AiFormField(key: 'product', label: _tr('المنتج', 'Product'), type: AiFormType.single,
          choices: products.map((p) => AiFormChoice(
            value: '${p.id}', label: p.name,
            detail: p.price.isEmpty ? null : p.price,
          )).toList()),
        AiFormField(key: 'quantity', label: _tr('الكمية', 'Quantity'),
          type: AiFormType.integer, min: 1, max: 20,
          initialNumber: draft.quantity),
      ],
      help: _tr('سنتحقق مجدداً من المخزون والمواصفات قبل إضافته للسلة.',
        'We will verify stock and options again before adding to your cart.'),
    );
  }

  Future<void> _promptOptions(Product product) async {
    final fields = <AiFormField>[];
    for (final option in product.options) {
      if (option.required && option.choices.isEmpty) {
        throw StateError('required_option_has_no_choices');
      }
      if (option.choices.isEmpty) continue;
      fields.add(AiFormField(
        key: option.key, label: option.label,
        type: option.type == ProductOptionType.multi
            ? AiFormType.multi : AiFormType.single,
        required: option.required,
        choices: option.choices.map((choice) => AiFormChoice(
          value: choice.key,
          label: choice.label,
          detail: choice.price.formatted,
        )).toList(),
      ));
    }
    if (fields.isEmpty) {
      await _promptAddress();
      return;
    }
    _addForm(stage: AiDraftStage.options,
      title: 'حدد مواصفات ${product.name}', fields: fields,
      help: 'الخيارات والأسعار مأخوذة من بيانات المنتج الفعلية.');
  }

  Future<void> _promptAddress() async {
    // The customer selects/saves an address in REAL app screens, never in AI output.
    // Keep legacy numeric choices compatible with restored V8.3 draft forms.
    _addForm(stage: AiDraftStage.address,
      title: _tr('وين بدك توصيل الطلب؟', 'Where should we deliver your order?'),
      fields: [AiFormField(
        key: 'address', label: _tr('اختيار عنوان التوصيل', 'Delivery address'),
        type: AiFormType.single,
        choices: [
          if (_chosenAddressId != null)
            AiFormChoice(value: 'recent', label: _tr(
              'استخدم العنوان المختار سابقاً: ${_chosenAddressLabel ?? 'عنوان محفوظ'}',
              'Use the previously selected address: ${_chosenAddressLabel ?? 'Saved address'}')),
          AiFormChoice(value: 'select', label: _tr(
            'اختار عنوان من العناوين المحفوظة', 'Choose a saved address')),
          AiFormChoice(value: 'new', label: _tr(
            'أضف عنواناً جديداً', 'Add a new address')),
          AiFormChoice(value: 'map', label: _tr(
            'حدّد عنواناً من الخريطة', 'Choose on the map')),
        ],
      )],
      help: _tr('سأفتح شاشة العناوين أو الخريطة، وبعد الحفظ أرجعك للشات لنكمل الدفع والمراجعة.',
        'I will open the address screen or map. Once saved, we will return here for payment and review.'),
    );
  }

  Future<void> _promptPayment() async {
    final draft = _draft!;
    final options = <AiFormChoice>[];
    final configMethods = Get.find<AppConfigController>().config.value?.paymentMethods ?? const <String>[];
    try {
      final methods = await Get.find<CatalogService>()
          .paymentMethods(draft.vendorId!).timeout(const Duration(seconds: 15));
      if (methods.cash) {
        for (final method in configMethods) {
          if (method != PaymentMethods.bankTransfer) {
            options.add(AiFormChoice(
              value: '$method:',
              label: method == PaymentMethods.cashOnDelivery
                  ? _tr('نقداً عند الاستلام', 'Cash on delivery') : method,
            ));
          }
        }
      }
      for (final gateway in methods.gateways) {
        options.add(AiFormChoice(
          value: '${PaymentMethods.bankTransfer}:${gateway.id}',
          label: _tr('تحويل: ${gateway.name}', 'Transfer: ${gateway.name}'),
        ));
      }
    } catch (_) {
      // If metadata is temporarily unavailable, selection happens in the
      // real checkout screen after the quote has been prepared.
    }
    if (options.isEmpty) {
      _draft!.paymentMethod = null;
      _draft!.paymentGatewayId = null;
      _promptReview();
      return;
    }
    _addForm(stage: AiDraftStage.payment,
      title: _tr('شو طريقة الدفع اللي بتفضّلها؟', 'How would you like to pay?'),
      fields: [AiFormField(key: 'payment', label: _tr('طريقة الدفع', 'Payment method'),
        type: AiFormType.single, choices: options)],
      help: 'هذا اختيار طريقة الدفع فقط؛ لا يوجد دفع أو تحويل الآن.');
  }

  void _promptReview() {
    final draft = _draft!;
    final item = draft.selectedItem;
    _addForm(
      stage: AiDraftStage.review,
      title: _tr('مراجعة اختياراتك قبل فتح الشاشات', 'Review selections before opening checkout'),
      fields: [AiFormField(
        key: 'go', label: _tr('شو بدك نعمل؟', 'What would you like to do?'),
        type: AiFormType.single,
        choices: [
          AiFormChoice(value: 'prepare', label: _tr(
            'جهّز الطلب واعرض الشاشات', 'Prepare order and show checkout screens')),
          AiFormChoice(value: 'cancel', label: _tr(
            'إلغاء تجهيز الطلب', 'Cancel order preparation')),
        ],
      )],
      help: '${item?.name ?? 'المنتج'} × ${draft.quantity}\n'
          'المتجر: ${_vendorNames[draft.vendorId] ?? 'الاسم غير متاح'}\n'
          'المواصفات: ${draft.optionsSummary ?? 'بدون إضافات'}\n'
          'التوصيل: ${draft.addressLabel ?? 'يحدد من شاشة التوصيل'}\n'
          'طريقة الدفع: ${draft.paymentLabel ?? 'تختار من شاشة التوصيل'}\n'
          'السعر النهائي يُحسب بواسطة Masar. التأكيد والدفع فقط من أزرار التطبيق الأصلية.',
      submit: _tr('متابعة', 'Continue'),
    );
  }

  /// Handles server-verified form values. It will reject stale forms,
  /// changed product IDs and choices not present in Masar's latest detail.
  Future<bool> submitForm(String formId, Map<String, dynamic> answers) async {
    final form = pendingForm;
    final draft = _draft;
    if (form == null || draft == null || form.id != formId || isSubmittingForm.value) return false;
    if (form.validate(answers).isNotEmpty) return false;
    isSubmittingForm.value = true;
    errorCode.value = null;
    try {
      switch (form.purpose) {
        case AiDraftStage.vendor: {
          final id = int.parse(answers['vendor'] as String);
          if (!draft.candidates.any((p) => p.vendorId == id)) return false;
          draft.vendorId = id;
          _markAnswered(form, answers);
          _promptProduct();
          break;
        }
        case AiDraftStage.product: {
          final id = int.parse(answers['product'] as String);
          final qty = answers['quantity'] is int
              ? answers['quantity'] as int : int.parse('${answers['quantity']}');
          final candidate = draft.candidates.where((p) =>
              p.id == id && p.vendorId == draft.vendorId).toList();
          if (candidate.isEmpty) return false;
          final product = await Get.find<CatalogService>().product(id);
          if (product.vendorId != draft.vendorId || !product.inStock ||
              (product.stock != null && product.stock! < qty)) {
            _assistant('هذا الخيار مش متوفر بالكمية المطلوبة. جرّب منتج أو عدد ثاني.');
            return false;
          }
          draft.productId = id;
          draft.quantity = qty;
          draft.options.clear();
          draft.optionsSummary = null;
          await _promptOptions(product);
          _markAnswered(form, answers);
          break;
        }
        case AiDraftStage.options: {
          final product = await Get.find<CatalogService>().product(draft.productId!);
          final allowed = {for (final o in product.options) o.key: o};
          for (final field in form.fields) {
            final opt = allowed[field.key];
            if (opt == null) return false;
            final raw = answers[field.key];
            final selection = raw is List
                ? raw.whereType<String>().toList()
                : raw is String && raw.isNotEmpty ? [raw] : <String>[];
            if (opt.required && selection.isEmpty) return false;
            if (opt.type != ProductOptionType.multi && selection.length > 1) return false;
            if (selection.any((id) => !opt.choices.any((c) => c.key == id))) return false;
            if (selection.isNotEmpty) draft.options[opt.key] = selection;
          }
          draft.optionsSummary = form.describe(answers);
          await _promptAddress();
          _markAnswered(form, answers);
          break;
        }
        case AiDraftStage.address: {
          final chosen = answers['address'] as String;
          Address? selected;
          if (chosen == 'recent') {
            final id = _chosenAddressId;
            if (id != null) selected = await _verifySavedAddress(id);
          } else if (chosen == 'new' || chosen == 'select' || chosen == 'map') {
            selected = await _openAddressScreen(
              chosen == 'new' ? AiAddressCommand.add
                : chosen == 'map' ? AiAddressCommand.map
                : AiAddressCommand.select,
            );
          } else {
            // Legacy V8.3 persisted forms may contain a verified address ID.
            final id = int.tryParse(chosen);
            if (id == null) return false;
            final current = await Get.find<AddressService>().list();
            final found = current.where((a) => a.id == id);
            if (found.isNotEmpty) selected = found.first;
          }
          if (selected == null) return false; // Cancel: leave the form active.
          final verified = await _verifySavedAddress(selected.id);
          if (verified == null) return false;
          draft.addressId = verified.id;
          draft.addressLabel = verified.label ?? verified.details;
          _chosenAddressId = verified.id;
          _chosenAddressLabel = draft.addressLabel;
          _markAnswered(form, {
            'address': chosen == 'new' || chosen == 'select' || chosen == 'map'
                ? chosen : '${verified.id}',
          });
          await _promptPayment();
          break;
        }
        case AiDraftStage.payment: {
          final raw = answers['payment'] as String;
          final split = raw.split(':');
          if (split.length != 2) return false;
          draft.paymentMethod = split.first;
          draft.paymentGatewayId = split.last.isEmpty ? null : int.tryParse(split.last);
          draft.paymentLabel = form.describe(answers);
          _markAnswered(form, answers);
          _promptReview();
          break;
        }
        case AiDraftStage.review: {
          final go = answers['go'] as String;
          _markAnswered(form, answers);
          if (go == 'cancel') {
            _draft = null;
            _assistant('تمام، ألغيت التجهيز. ما أرسلت أي طلب ولا نفذت دفع.');
          } else {
            draft.stage = AiDraftStage.finished;
            await _save();
            // Queue after returning from the button handler to avoid
            // rebuilding the chat widget while navigating away.
            unawaited(_runDraft(draft));
          }
          break;
        }
        default:
          return false;
      }
      await _save();
      return true;
    } catch (_) {
      errorCode.value = 'form_step_failed';
      _assistant('ما قدرت أكمل الخطوة من السيرفر. جرّب مرة ثانية بدون تغيير اختيارك.');
      return false;
    } finally {
      isSubmittingForm.value = false;
    }
  }

  void _markAnswered(AiChatForm form, Map<String, dynamic> answers) {
    for (var i = messages.length - 1; i >= 0; i--) {
      final message = messages[i];
      if (message.form?.id == form.id && !message.formAnswered) {
        messages[i] = message.copyWith(formAnswered: true);
        break;
      }
    }
    messages.add(AiChatMessage(
      role: 'user', text: form.describe(answers), createdAt: DateTime.now(),
    ));
  }

  /// Very short follow-ups can fill the active form without leaving chat.
  /// All other text goes to Gemini for normal conversation/suggestions.
  Future<bool> _answerPendingFromText(String text) async {
    final form = pendingForm;
    if (form == null) return false;
    final normalized = text.trim().toLowerCase();
    // A question about option #2 is NOT consent to select option #2.
    // Route questions to the normal conversational model instead.
    if (RegExp(r'^(شو|ايش|إيش|كيف|ليش|ليه|لماذا|هل|وين|كم |قديش|ما الفرق|ممكن تشرح)')
        .hasMatch(normalized)) return false;
    if (form.purpose == AiDraftStage.review) {
      if (RegExp(r'^(نعم|كمل|تابع|جهز|تمام|موافق)$').hasMatch(normalized)) {
        return submitForm(form.id, {'go': 'prepare'});
      }
      if (RegExp(r'^(لا|الغاء|ألغي|بلاش|وقف)$').hasMatch(normalized)) {
        return submitForm(form.id, {'go': 'cancel'});
      }
    }
    if (form.purpose == AiDraftStage.address &&
        (normalized.contains('عنوان جديد') || normalized.contains('الخريطة'))) {
      return submitForm(form.id, {'address': 'new'});
    }
    if (form.purpose == AiDraftStage.product) {
      final productField = form.fields.firstWhere((f) => f.key == 'product');
      AiFormChoice? selected;
      final index = _spokenIndex(normalized);
      if (index != null && index < productField.choices.length) {
        selected = productField.choices[index];
      } else {
        for (final choice in productField.choices) {
          if (normalized.contains(choice.label.trim().toLowerCase())) {
            if (selected != null) return false; // ambiguous product names
            selected = choice;
          }
        }
      }
      if (selected == null && productField.choices.length == 1 &&
          RegExp(r'^(عدد|العدد|الكمية|بدي|خد|خذ|عايز)').hasMatch(normalized)) {
        selected = productField.choices.first;
      }
      if (selected != null) {
        final match = RegExp(r'(?:عدد|العدد|كمية|الكمية)\s*(\d{1,2})').firstMatch(normalized);
        final qty = match == null ? _draft?.quantity ?? 1 : int.parse(match.group(1)!);
        return submitForm(form.id, {'product': selected.value, 'quantity': qty});
      }
    }
    if (form.fields.length == 1 && form.fields.first.type == AiFormType.single) {
      final field = form.fields.first;
      final index = _spokenIndex(normalized);
      if (index != null && index < field.choices.length) {
        return submitForm(form.id, {field.key: field.choices[index].value});
      }
      final matches = field.choices.where((c) =>
          c.label.trim().toLowerCase() == normalized ||
          normalized.contains(c.label.trim().toLowerCase())).toList();
      if (matches.length == 1) {
        return submitForm(form.id, {field.key: matches.first.value});
      }
    }
    return false;
  }

  int? _spokenIndex(String words) {
    if (RegExp(r'(?:الأول|الاول|اول|رقم 1)').hasMatch(words)) return 0;
    if (RegExp(r'(?:الثاني|التاني|ثاني|تاني|رقم 2)').hasMatch(words)) return 1;
    if (RegExp(r'(?:الثالث|ثالث|رقم 3)').hasMatch(words)) return 2;
    if (RegExp(r'(?:الرابع|رابع|رقم 4)').hasMatch(words)) return 3;
    if (RegExp(r'(?:الخامس|خامس|رقم 5)').hasMatch(words)) return 4;
    return null;
  }

  Future<void> _runDraft(AiOrderDraft draft) async {
    final item = draft.selectedItem;
    if (item == null || isPreparingOrder.value) return;
    isPreparingOrder.value = true;
    errorCode.value = null;
    orderProgress.value = 'عم أتأكد من المنتج والخيارات...';
    try {
      final result = await AiGuidedCheckout().prepare(
        item,
        quantity: draft.quantity,
        selectedOptions: draft.options,
        preferredAddressId: draft.addressId,
        preferredPaymentMethod: draft.paymentMethod,
        preferredPaymentGatewayId: draft.paymentGatewayId,
        onProgress: (value) => orderProgress.value = value,
      );
      if (result != null && result.isNotEmpty) _assistant(result);
      if (Get.isRegistered<AiTaskController>()) {
        final phase = Get.find<AiTaskController>().phase.value;
        if (phase == AiTaskPhase.failed || phase == AiTaskPhase.stopped) {
          // The old form has already been answered. Create a fresh review
          // choice for explicit retry; never silently execute again.
          _draft = draft;
          _promptReview();
          await _save();
        }
      }
    } catch (_) {
      errorCode.value = 'order_preparation_failed';
      _draft = draft;
      _promptReview();
      await _save();
    } finally {
      isPreparingOrder.value = false;
      orderProgress.value = '';
    }
  }

  Future<void> toggleVoice() async {
    if (isSending.value || isSubmittingForm.value) return;
    if (isListening.value) {
      await _speech.stopListening();
      isListening.value = false;
      return;
    }
    errorCode.value = null;
    _voiceSubmitted = false;
    final ready = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') isListening.value = false;
      },
      onError: (code) {
        isListening.value = false;
        errorCode.value = code;
      },
    );
    if (!ready) { errorCode.value = 'speech_unavailable'; return; }
    isListening.value = true;
    final language = chatLanguage.value;
    await _speech.listen(language: language, onResult: (result) {
      final words = result.recognizedWords.trim();
      if (language == 'ar' && result.finalResult && words.isNotEmpty &&
          !RegExp(r'[\u0600-\u06FF]').hasMatch(words)) {
        errorCode.value = 'speech_wrong_language';
        isListening.value = false;
        return;
      }
      if (words.isNotEmpty) {
        input.text = words;
        input.selection = TextSelection.collapsed(offset: input.text.length);
      }
      if (result.finalResult && words.isNotEmpty && !_voiceSubmitted) {
        _voiceSubmitted = true;
        isListening.value = false;
        unawaited(send(words));
      }
    });
  }

  /// Top-right speaker actually speaks the latest assistant reply immediately.
  /// The language is chosen from message text (Arabic / English).
  Future<void> toggleVoiceReplies() async {
    if (voiceReplies.value) {
      voiceReplies.value = false;
      unawaited(_save());
      await _speech.stopSpeaking();
      return;
    }
    voiceReplies.value = true;
    unawaited(_save());
    final recent = messages.reversed.where((m) => !m.isUser).firstOrNull;
    await speakMessage(recent?.text ?? _tr(
      'أهلاً! أنا مساعد عَمّار، احكيلي شو بتحتاج.',
      'Hello! I am Amar, your assistant. How can I help?'));
  }

  Future<void> speakMessage(String text) async {
    if (text.trim().isEmpty) return;
    final spoken = await _speech.speak(text,
      language: aiSpeechLanguageFor(text, fallback: chatLanguage.value));
    if (!spoken) {
      voiceReplies.value = false;
      errorCode.value = 'speech_voice_missing';
    }
  }

  Future<Address?> _verifySavedAddress(int id) async {
    final accounts = await Get.find<AddressService>().list()
        .timeout(const Duration(seconds: 20));
    return accounts.firstWhereOrNull((a) => a.id == id);
  }

  /// Opens the existing app address form / a real saved-address chooser.
  /// Each child route pops to this chat with an Address or null on cancel.
  Future<Address?> _openAddressScreen(AiAddressCommand command) async {
    if (command == AiAddressCommand.add) {
      return await Get.toNamed<Address>(
        AppRoutes.checkoutAddressNew,
        arguments: const AddressFormArgs(),
      );
    }
    return await Get.to<Address>(
      () => AiAddressSelectionScreen(
        openMapImmediately: command == AiAddressCommand.map,
        language: chatLanguage.value,
      ),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 300),
    );
  }

  /// User can ask to add/select a location in normal chat OR mid-checkout.
  /// Never continue the draft unless the address was saved to Masar and
  /// verified again by the account's AddressService.
  Future<void> openAddressFlow(AiAddressCommand command) async {
    if (isNavigatingAddress.value || isSubmittingForm.value ||
        isPreparingOrder.value) return;
    isNavigatingAddress.value = true;
    errorCode.value = null;
    _assistant(_tr(
      command == AiAddressCommand.add ? 'رح أفتح شاشة إضافة عنوان جديد. بعد الحفظ بنرجع نكمل هون.'
        : command == AiAddressCommand.map ? 'رح أفتح الخريطة لتحديد الموقع، وبعد الحفظ نرجع للشات.'
        : 'رح أفتح شاشة اختيار العنوان. بعدها بنرجع نكمل الطلب.',
      command == AiAddressCommand.add ? 'Opening Add Address. After saving, we will continue here.'
        : command == AiAddressCommand.map ? 'Opening the map. We will return here after saving.'
        : 'Opening saved addresses. We will continue here afterward.',
    ));
    try {
      final picked = await _openAddressScreen(command);
      if (picked == null) {
        _assistant(_tr('رجعنا للشات بدون اختيار عنوان. تقدر تختار وقت ما بدك.',
          'Back in chat. No address selected; you can choose one anytime.'));
        return;
      }
      final address = await _verifySavedAddress(picked.id);
      if (address == null) {
        _assistant(_tr('العنوان ما تأكد من السيرفر. جرّب الاختيار مرة ثانية.',
          'The address was not verified on the server. Please retry.'));
        return;
      }
      _chosenAddressId = address.id;
      _chosenAddressLabel = address.label ?? address.details;
      final draft = _draft;
      final form = pendingForm;
      if (draft != null && draft.stage == AiDraftStage.address &&
          form != null && form.purpose == AiDraftStage.address) {
        draft.addressId = address.id;
        draft.addressLabel = address.label ?? address.details;
        _markAnswered(form, const {'address': 'select'});
        await _promptPayment();
      }
      _assistant(_tr(
        'تمام، تم اختيار العنوان «${address.label ?? address.details ?? 'عنوان محفوظ'}» من السيرفر. نكمل باقي الخطوات هون.',
        'Address «${address.label ?? address.details ?? 'Saved address'}» is confirmed. Let’s continue here.',
      ));
      await _save();
    } catch (_) {
      errorCode.value = 'address_navigation_failed';
      _assistant(_tr('صار خطأ بفتح العنوان أو حفظه. ما تغير الطلب، جرّب مرة ثانية.',
        'Could not open or save the address. Your draft is unchanged; please retry.'));
    } finally {
      isNavigatingAddress.value = false;
    }
  }

  void openItem(AiCatalogItem item) => _executor.openItem(item);

  Future<void> clearHistory() async {
    if (isSubmittingForm.value || isPreparingOrder.value) return;
    messages.clear();
    _draft = null;
    _chosenAddressId = null;
    _chosenAddressLabel = null;
    errorCode.value = null;
    await _save();
  }

  @override
  void onClose() {
    unawaited(_speech.detach());
    input.dispose();
    super.onClose();
  }
}
