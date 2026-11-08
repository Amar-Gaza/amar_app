import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/customer/ai_chat_controller.dart';
import '../../../core/localization/ai_labels.dart';
import '../../../data/models/ai/ai_chat_message.dart';
import '../../../data/models/ai/ai_intent.dart';
import '../../widgets/ai/ai_chat_form_card.dart';

class AiAssistantScreen extends GetView<AiChatController> {
  const AiAssistantScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final labels = AiLabels(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(labels.title),
        actions: [
          Obx(
            () => IconButton(
              tooltip: controller.voiceReplies.value
                  ? labels.speakerOn
                  : labels.speakerOff,
              icon: Icon(
                controller.voiceReplies.value
                    ? Icons.volume_up
                    : Icons.volume_off,
              ),
              onPressed: controller.toggleVoiceReplies,
            ),
          ),
          IconButton(
            tooltip: labels.clear,
            icon: const Icon(
              Icons.delete_outline,
            ),
            onPressed: () => Get.dialog<void>(
              AlertDialog(
                title: Text(labels.clear),
                content: Text(
                  labels.isArabic
                      ? 'بدك تمسح رسائل المساعد المحفوظة على هذا الجهاز؟'
                      : 'Clear saved messages on this device?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back<void>(),
                    child: Text(
                      labels.isArabic ? 'إلغاء' : 'Cancel',
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      controller.clearHistory();
                      Get.back<void>();
                    },
                    child: Text(labels.clear),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.messages.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(
                        30,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.smart_toy_outlined,
                            size: 48,
                            color: colors.primary,
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Text(
                            labels.welcome,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              ActionChip(
                                label: const Text(
                                  'بدي شركات سباكة',
                                ),
                                onPressed: () => controller.send(
                                  'بدي شركات سباكة',
                                ),
                              ),
                              ActionChip(
                                label: const Text(
                                  'دورلي على حداد',
                                ),
                                onPressed: () => controller.send(
                                  'دورلي على حداد',
                                ),
                              ),
                              ActionChip(
                                label: const Text(
                                  'شو الأقسام عندكم؟',
                                ),
                                onPressed: () => controller.send(
                                  'شو الأقسام عندكم؟',
                                ),
                              ),
                              ActionChip(
                                label: const Text(
                                  'اطلبلي كورس إفرنجي',
                                ),
                                onPressed: () => controller.send(
                                  'اطلبلي كورس إفرنجي',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.messages.length,
                  itemBuilder: (_, index) {
                    final message = controller
                        .messages[controller.messages.length - 1 - index];

                    return _MessageBubble(
                      message: message,
                      onOpen: controller.openItem,
                      onPrepare: controller.prepareOrder,
                      chat: controller,
                      onSuggestion: (suggestion) => controller.send(
                        suggestion,
                      ),
                    );
                  },
                );
              }),
            ),

            // Error messages.
            Obx(() {
              final error = controller.errorCode.value;

              if (error == null) {
                return const SizedBox.shrink();
              }

              final description = _errorText(
                labels,
                error,
              );

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 5,
                ),
                child: Text(
                  kDebugMode ? '$description\nError: $error' : description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.error,
                    fontSize: 12,
                  ),
                ),
              );
            }),

            // Guided checkout progress.
            Obx(
              () => controller.isPreparingOrder.value
                  ? Padding(
                      padding: const EdgeInsets.all(
                        10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              controller.orderProgress.value,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Voice listening state.
            Obx(
              () => controller.isListening.value
                  ? Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        labels.listening,
                        style: TextStyle(
                          color: colors.primary,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Input and microphone.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                8,
                12,
                8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.input,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: labels.hint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                      ),
                      onSubmitted: (_) => controller.send(),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Obx(
                    () => IconButton.filledTonal(
                      tooltip: controller.isListening.value
                          ? labels.stopListen
                          : labels.listen,
                      onPressed: controller.isSending.value
                          ? null
                          : controller.toggleVoice,
                      icon: Icon(
                        controller.isListening.value
                            ? Icons.stop_circle
                            : Icons.mic,
                      ),
                    ),
                  ),
                  Obx(
                    () => IconButton.filled(
                      tooltip: labels.send,
                      onPressed: controller.isSending.value
                          ? null
                          : () => controller.send(),
                      icon: controller.isSending.value
                          ? const SizedBox.square(
                              dimension: 17,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.send,
                            ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                bottom: 5,
              ),
              child: Text(
                labels.disclaimer,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _errorText(
    AiLabels labels,
    String code,
  ) {
    if (code.startsWith(
      'unauthenticated',
    )) {
      return labels.login;
    }

    if (code == 'speech_timeout') {
      return labels.noSpeech;
    }

    if (code == 'speech_language_missing') {
      return labels.missingLanguage;
    }

    if (code == 'speech_wrong_language') {
      return labels.wrongLanguage;
    }

    if (code == 'speech_voice_missing') {
      return labels.noVoice;
    }

    if (code == 'form_step_failed') {
      return labels.isArabic
          ? 'تعذّر إكمال الخطوة من السيرفر؛ راجع اتصال الإنترنت وجرب مرة ثانية.'
          : 'Could not complete the step; please retry.';
    }

    if (code == 'order_preparation_failed') {
      return labels.isArabic
          ? 'تعذّر تجهيز الطلب. راجع بيانات المنتج والسلة.'
          : 'Could not prepare the order. Check the item and cart.';
    }

    return labels.unavailable;
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.onOpen,
    required this.onPrepare,
    required this.onSuggestion,
    required this.chat,
  });

  final AiChatMessage message;
  final AiChatController chat;

  final void Function(
    AiCatalogItem,
  ) onOpen;

  final Future<void> Function(
    AiCatalogItem,
    int,
  ) onPrepare;

  final void Function(
    String,
  ) onSuggestion;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Align(
      alignment: message.isUser
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.9,
        ),
        child: Column(
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Chat message.
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 11,
              ),
              margin: const EdgeInsets.only(
                bottom: 7,
              ),
              decoration: BoxDecoration(
                color: message.isUser
                    ? colors.primaryContainer
                    : colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                message.text,
              ),
            ),

            // Server-backed product cards.
            if (message.results.isNotEmpty)
              ...message.results.asMap().entries.map((entry) {
                final item = entry.value;
                // V8.1 includes vendor_name. Older builds got it in the
                // description; hide that duplicate text when the field exists.
                final description = item.vendorName.isEmpty
                    ? item.description
                    : item.description.replaceFirst(
                        RegExp(r'\s*\|\s*المتجر:\s*[^|]*$'), '').trim();

                return Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.only(
                    bottom: 7,
                  ),
                  child: InkWell(
                    onTap: () => onOpen(item),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        10,
                      ),
                      child: Row(
                        children: [
                          if (item.imageUrl.startsWith(
                            'https://',
                          ))
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                9,
                              ),
                              child: Image.network(
                                item.imageUrl,
                                width: 42,
                                height: 42,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.image_not_supported_outlined,
                                ),
                              ),
                            )
                          else
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: colors.primaryContainer,
                              child: Text(
                                '${entry.key + 1}',
                                style: TextStyle(
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                            ),

                          const SizedBox(
                            width: 10,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleSmall,
                                ),
                                if (description.isNotEmpty)
                                  Text(
                                    description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                if (item.vendorName.isNotEmpty)
                                  Text(
                                    'المتجر: ${item.vendorName}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.labelSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                if (item.price.isNotEmpty)
                                  Text(
                                    item.price,
                                    style: TextStyle(
                                      color: colors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                if (item.category.isNotEmpty)
                                  Text(
                                    item.category,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                if (item.address.isNotEmpty)
                                  Text(
                                    item.address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                if (item.isOpenNow == true)
                                  const Text(
                                    'مفتوح الآن',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.green,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Prepare order button.
                          if (message.canPrepareOrder &&
                              (item.type == 'product' ||
                                  item.type == 'service'))
                            SizedBox(
                              width: 112,
                              child: FilledButton.tonal(
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size(0, 44),
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                ),
                                onPressed: () => onPrepare(
                                  item,
                                  message.orderQuantity,
                                ),
                                child: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text('اختار للطلب'),
                                ),
                              ),
                            )
                          else
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

            // Real, validated radio / checkbox / quantity forms inside chat.
            if (message.form != null)
              AiChatFormCard(
                key: ValueKey(message.form!.id),
                form: message.form!,
                enabled: !message.formAnswered &&
                    chat.isFormActive(message.form!.id) &&
                    !chat.isSubmittingForm.value,
                onSubmit: (answers) => chat.submitForm(message.form!.id, answers),
              ),

            // Follow-up suggestions.
            if (message.suggestions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 3,
                  children: message.suggestions
                      .map(
                        (suggestion) => ActionChip(
                          label: Text(
                            suggestion,
                          ),
                          onPressed: () => onSuggestion(
                            suggestion,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

            const SizedBox(
              height: 7,
            ),
          ],
        ),
      ),
    );
  }
}
