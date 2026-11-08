
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/constants/storage_keys.dart';
import '../../core/network/ai_gateway_client.dart';
import '../../core/storage/app_preferences.dart';
import '../../data/models/ai/ai_chat_message.dart';
import '../../data/models/ai/ai_intent.dart';
import '../../data/services/shared/ai_speech_service.dart';
import '../shared/session_controller.dart';
import 'ai_action_executor.dart';
import 'ai_guided_checkout.dart';
import 'ai_task_controller.dart';

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
  final errorCode = RxnString();
  final isPreparingOrder = false.obs;
  final orderProgress = ''.obs;
  int? _customerId;
  bool _voiceSubmitted = false;

  @override
  void onInit() {
    super.onInit();
    _customerId = _session.user.value?.id;
    if (_customerId == null) return;
    final snapshot = _prefs.customerState(StorageKeys.customerAiChat, customerId: _customerId);
    if (snapshot?['messages'] is! List) return;
    final restored = <AiChatMessage>[];
    for (final raw in (snapshot!['messages'] as List).take(60)) {
      try {
        restored.add(AiChatMessage.fromJson(Map<String, dynamic>.from(raw as Map)));
      } catch (_) { /* Skip corrupted entries. */ }
    }
    messages.assignAll(restored);
  }

  Future<void> _save() async {
    final id = _customerId;
    if (id == null) return;
    final last = messages.length > 60 ? messages.skip(messages.length - 60).toList() : messages.toList();
    await _prefs.saveCustomerState(
      StorageKeys.customerAiChat,
      {'schema': 4, 'messages': last.map((m) => m.toJson()).toList()},
      customerId: id,
    );
  }

  List<AiCatalogItem> get lastResults {
    for (final m in messages.reversed) {
      if (!m.isUser && m.results.isNotEmpty) return m.results;
    }
    return const [];
  }

  Future<void> send([String? provided]) async {
    final text = (provided ?? input.text).trim();
    if (text.isEmpty || isSending.value || isPreparingOrder.value) return;
    if (text.length > 2000) {
      errorCode.value = 'message_too_long';
      return;
    }

    // Acquire the lock BEFORE the first await. Otherwise two quick taps can
    // submit the same message while stopSpeaking() has not completed yet.
    isSending.value = true;
    errorCode.value = null;
    AiGatewayReply? response;

    try {
      if (isListening.value) {
        isListening.value = false;
        await _speech.stopListening();
      }
      await _speech.stopSpeaking();
      input.clear();

      final context = messages.reversed.take(12).toList().reversed
          .map((m) => {
        'role': m.role,
        // Keep request body safely below Cloudflare's 16 KB limit.
        'text': m.text.length > 450
            ? m.text.substring(0, 450)
            : m.text,
      }).toList();
      final previouslyShown = lastResults;

      messages.add(AiChatMessage(
        role: 'user', text: text, createdAt: DateTime.now(),
      ));
      await _save();

      response = await _gateway.chat(
        message: text,
        locale: Get.locale?.languageCode ?? 'ar',
        history: context,
        lastResults: previouslyShown,
      );

      messages.add(AiChatMessage(
        role: 'assistant',
        text: response.reply,
        createdAt: DateTime.now(),
        results: response.results,
        suggestions: response.suggestions,
        canPrepareOrder: response.action == 'prepare_order',
        orderQuantity: response.quantity,
      ));
      await _save();

      if (voiceReplies.value) {
        final spoken = await _speech.speak(
          response.reply,
          language: Get.locale?.languageCode ?? 'ar',
        );
        if (!spoken) errorCode.value = 'speech_voice_missing';
      }
    } on AiGatewayException catch (error) {
      errorCode.value = error.code;
    } catch (_) {
      errorCode.value = 'network_error';
    } finally {
      isSending.value = false;
    }

    if (response != null && !isPreparingOrder.value) {
      if (response.action == 'prepare_order' &&
          response.results.length == 1 &&
          _sameProductName(response.query, response.results.first.name)) {
        await prepareOrder(response.results.first, response.quantity);
      } else {
        _executor.run(response);
      }
    }
  }

  bool _sameProductName(String requested, String actual) {
    String normalize(String text) => text
        .toLowerCase()
        .replaceAll(RegExp(r'[\u064b-\u065f\u0670\u0640]'), '')
        .replaceAll(RegExp('[أإآ]'), 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final wanted = normalize(requested);
    return wanted.length >= 3 && normalize(actual) == wanted;
  }

  Future<void> toggleVoice() async {
    if (isSending.value) return;
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
    await _speech.listen(
      language: language,
      onResult: (result) {
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
      },
    );
  }

  void toggleVoiceReplies() {
    voiceReplies.value = !voiceReplies.value;
    if (!voiceReplies.value) unawaited(_speech.stopSpeaking());
  }

  void openItem(AiCatalogItem item) => _executor.openItem(item);

  /// Only prepare a draft; no placeOrder() call or payment authorization.
  Future<void> prepareOrder(AiCatalogItem item, int qty) async {
    if (isPreparingOrder.value || isSending.value ||
        (Get.isRegistered<AiTaskController>() &&
            Get.find<AiTaskController>().busy)) return;
    isPreparingOrder.value = true;
    errorCode.value = null;
    orderProgress.value = 'عم أتأكد من المنتج والمواصفات...';
    try {
      final result = await AiGuidedCheckout().prepare(
        item,
        quantity: qty,
        onProgress: (value) => orderProgress.value = value,
      );
      if (result != null && result.isNotEmpty) {
        messages.add(AiChatMessage(
          role: 'assistant', text: result, createdAt: DateTime.now(),
        ));
        await _save();
      }
    } catch (_) {
      errorCode.value = 'order_preparation_failed';
    } finally {
      isPreparingOrder.value = false;
      orderProgress.value = '';
    }
  }

  Future<void> clearHistory() async {
    messages.clear();
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
