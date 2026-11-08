import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
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
  final isPreparingOrder = false.obs;
  final isSubmittingForm = false.obs;
  final errorCode = RxnString();
  final orderProgress = ''.obs;

  AiOrderDraft? _draft;
  int? _customerId;
  bool _voiceSubmitted = false;
  int _formSeq = 0;
  Future<void> _lastSave = Future<void>.value();
  final Map<int, String> _vendorNames = {};

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
    _customerId = _session.user.value?.id;
    if (_customerId == null) return;
    final snapshot = _prefs.customerState(StorageKeys.customerAiChat, customerId: _customerId);
    if (snapshot == null) return;
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
    _assistant('حدّد الخيارات التالية وبكمل معك نفس الطلب:', form: form);
  }

  /// Normal open-ended chat is still handled by the authenticated gateway.
  /// Existing forms remain visible while the user asks unrelated questions.
  Future<void> send([String? provided]) async {
    final text = (provided ?? input.text).trim();
    if (text.isEmpty || isSending.value || isPreparingOrder.value || isSubmittingForm.value) return;
    if (text.length > 2000) { errorCode.value = 'message_too_long'; return; }

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
        message: text, locale: Get.locale?.languageCode ?? 'ar',
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
            language: Get.locale?.languageCode ?? 'ar')) {
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
      title: 'من أي شركة أو متجر بدك تشتري؟',
      fields: [AiFormField(
        key: 'vendor', label: 'الشركة / المتجر', type: AiFormType.single,
        choices: vendorIds.map((id) => AiFormChoice(
          value: '$id', label: _vendorNames[id]!,
          detail: '${draft.candidates.where((item) => item.vendorId == id).length} منتج ضمن النتائج',
        )).toList(),
      )],
      help: 'هاي الشركات مرتبطة بمنتجات حقيقية رجّعها السيرفر.',
    );
  }

  void _promptProduct() {
    final draft = _draft!;
    final products = draft.candidates.where((p) => p.vendorId == draft.vendorId).toList();
    if (products.isEmpty) { _assistant('ما في منتجات متوفرة ضمن المتجر المختار.'); return; }
    _addForm(
      stage: AiDraftStage.product,
      title: 'اختار المنتج والعدد المطلوب',
      fields: [
        AiFormField(key: 'product', label: 'المنتج', type: AiFormType.single,
          choices: products.map((p) => AiFormChoice(
            value: '${p.id}', label: p.name,
            detail: p.price.isEmpty ? null : p.price,
          )).toList()),
        AiFormField(key: 'quantity', label: 'الكمية',
          type: AiFormType.integer, min: 1, max: 20,
          initialNumber: draft.quantity),
      ],
      help: 'سنتحقق مجدداً من المخزون والمواصفات قبل إضافته للسلة.',
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
    final addresses = await Get.find<AddressService>()
        .list().timeout(const Duration(seconds: 20));
    _addForm(stage: AiDraftStage.address,
      title: 'وين بدك توصيل الطلب؟',
      fields: [AiFormField(
        key: 'address', label: 'عنوان التوصيل',
        type: AiFormType.single,
        choices: [
          for (final a in addresses)
            AiFormChoice(value: '${a.id}',
              label: a.label ?? 'عنوان ${a.id}',
              detail: a.details),
          const AiFormChoice(value: 'new', label: 'إضافة عنوان جديد من الخريطة'),
        ],
      )],
      help: 'اختار عنواناً محفوظاً أو حدّد نقطة جديدة بنفسك على الخريطة.',
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
                  ? 'نقداً عند الاستلام' : method,
            ));
          }
        }
      }
      for (final gateway in methods.gateways) {
        options.add(AiFormChoice(
          value: '${PaymentMethods.bankTransfer}:${gateway.id}',
          label: 'تحويل: ${gateway.name}',
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
      title: 'شو طريقة الدفع اللي بتفضّلها؟',
      fields: [AiFormField(key: 'payment', label: 'طريقة الدفع',
        type: AiFormType.single, choices: options)],
      help: 'هذا اختيار طريقة الدفع فقط؛ لا يوجد دفع أو تحويل الآن.');
  }

  void _promptReview() {
    final draft = _draft!;
    final item = draft.selectedItem;
    _addForm(
      stage: AiDraftStage.review,
      title: 'مراجعة اختياراتك قبل فتح الشاشات',
      fields: const [AiFormField(
        key: 'go', label: 'شو بدك نعمل؟', type: AiFormType.single,
        choices: [
          AiFormChoice(value: 'prepare', label: 'جهّز الطلب واعرض الشاشات'),
          AiFormChoice(value: 'cancel', label: 'إلغاء تجهيز الطلب'),
        ],
      )],
      help: '${item?.name ?? 'المنتج'} × ${draft.quantity}\n'
          'المتجر: ${_vendorNames[draft.vendorId] ?? 'الاسم غير متاح'}\n'
          'المواصفات: ${draft.optionsSummary ?? 'بدون إضافات'}\n'
          'التوصيل: ${draft.addressLabel ?? 'يحدد من شاشة التوصيل'}\n'
          'طريقة الدفع: ${draft.paymentLabel ?? 'تختار من شاشة التوصيل'}\n'
          'السعر النهائي يُحسب بواسطة Masar. التأكيد والدفع فقط من أزرار التطبيق الأصلية.',
      submit: 'متابعة',
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
          final id = answers['address'] as String;
          if (id == 'new') {
            final created = await Get.toNamed<Address>(
              AppRoutes.checkoutAddressNew,
              arguments: const AddressFormArgs(),
            );
            if (created == null) return false;
            draft.addressId = created.id;
            draft.addressLabel = created.label;
          } else {
            final current = await Get.find<AddressService>().list();
            final selected = current.where((a) => '${a.id}' == id);
            if (selected.isEmpty) return false;
            draft.addressId = selected.first.id;
            draft.addressLabel = selected.first.label;
          }
          await _promptPayment();
          _markAnswered(form, answers);
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
    final language = Get.locale?.languageCode ?? 'ar';
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

  void toggleVoiceReplies() {
    voiceReplies.value = !voiceReplies.value;
    if (!voiceReplies.value) unawaited(_speech.stopSpeaking());
  }

  void openItem(AiCatalogItem item) => _executor.openItem(item);

  Future<void> clearHistory() async {
    if (isSubmittingForm.value || isPreparingOrder.value) return;
    messages.clear();
    _draft = null;
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
