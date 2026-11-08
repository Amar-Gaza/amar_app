import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/customer/ai_chat_controller.dart';
import '../../../controllers/customer/ai_address_command.dart';
import '../../../data/models/ai/ai_chat_message.dart';
import '../../../data/models/ai/ai_intent.dart';
import '../../widgets/ai/ai_chat_form_card.dart';

/// A warm, premium conversational experience. This screen changes only AI UI;
/// the app's checkout and address routes remain the source of truth.
class AiAssistantScreen extends GetView<AiChatController> {
  const AiAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Obx(() {
      final ar = controller.chatLanguage.value != 'en';
      String t(String arabic, String english) => ar ? arabic : english;
      return Scaffold(
        backgroundColor: colors.surface,
        appBar: AppBar(
          backgroundColor: colors.surface,
          elevation: 0,
          titleSpacing: 4,
          title: Row(children: [
            const _AmarMark(size: 42),
            const SizedBox(width: 9),
            Flexible(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(t('عَمّار الذكي', 'Amar AI'),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800)),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(
                    color: Color(0xff28bd8b), shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Flexible(child: Text(t('مساعدك في المنتجات والخدمات', 'Products & services assistant'),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall)),
                ]),
              ],
            )),
          ]),
          actions: [
            IconButton(
              tooltip: controller.voiceReplies.value
                  ? t('إيقاف الرد الصوتي', 'Turn off spoken replies')
                  : t('تفعيل الرد الصوتي', 'Turn on spoken replies'),
              style: IconButton.styleFrom(
                backgroundColor: controller.voiceReplies.value
                    ? colors.primaryContainer : null,
              ),
              onPressed: controller.toggleVoiceReplies,
              icon: Icon(controller.voiceReplies.value
                  ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                  color: controller.voiceReplies.value ? colors.primary : null),
            ),
            PopupMenuButton<String>(
              tooltip: t('اللغة والإعدادات', 'Language & settings'),
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) {
                if (value == 'ar' || value == 'en') {
                  controller.setChatLanguage(value);
                } else if (value == 'clear') {
                  _confirmClear(context, ar);
                }
              },
              itemBuilder: (context) => [
                CheckedPopupMenuItem(value: 'ar', checked: ar,
                  child: const Text('العربية')),
                CheckedPopupMenuItem(value: 'en', checked: !ar,
                  child: const Text('English')),
                const PopupMenuDivider(),
                PopupMenuItem(value: 'clear',
                  child: Text(t('مسح المحادثة', 'Clear chat'))),
              ],
            ),
          ],
        ),
        body: Directionality(
          textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
          child: SafeArea(
          child: Column(children: [
            Expanded(child: Obx(() {
              if (controller.messages.isEmpty) {
                return _WelcomePanel(
                  arabic: ar,
                  onTap: controller.send,
                  onAddress: () => controller.openAddressFlow(
                    AiAddressCommand.select),
                );
              }
              return ListView.builder(
                reverse: true,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 10),
                itemCount: controller.messages.length,
                itemBuilder: (_, index) {
                  final message = controller.messages[
                    controller.messages.length - 1 - index];
                  return _MessageBubble(
                    message: message,
                    onOpen: controller.openItem,
                    onPrepare: controller.prepareOrder,
                    chat: controller,
                    onSuggestion: controller.send,
                  );
                },
              );
            })),
            Obx(() {
              final code = controller.errorCode.value;
              if (code == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 6),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: colors.errorContainer,
                  ),
                  child: Row(children: [
                    Icon(Icons.info_outline, color: colors.onErrorContainer, size: 19),
                    const SizedBox(width: 9),
                    Expanded(child: Text(
                      kDebugMode ? '${_errorText(ar, code)} ($code)' : _errorText(ar, code),
                      style: TextStyle(color: colors.onErrorContainer, fontSize: 12),
                    )),
                  ]),
                ),
              );
            }),
            Obx(() => controller.isPreparingOrder.value
              ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                child: Row(children: [
                  const SizedBox.square(dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(controller.orderProgress.value,
                    style: Theme.of(context).textTheme.bodySmall)),
                ]),
              ) : const SizedBox.shrink()),
            Obx(() => controller.isListening.value
              ? Padding(padding: const EdgeInsets.all(6),
                  child: Text(t('أنا بسمعك الآن…', 'I am listening…'),
                    style: TextStyle(color: colors.primary)))
              : const SizedBox.shrink()),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 9, 12, 6),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(top: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: 0.5))),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  IconButton(
                    tooltip: t('اختيار عنوان', 'Choose address'),
                    onPressed: controller.isNavigatingAddress.value
                        ? null : () => controller.openAddressFlow(
                            AiAddressCommand.select),
                    icon: Icon(Icons.add_location_alt_outlined,
                      color: colors.primary),
                  ),
                  Expanded(child: TextField(
                    controller: controller.input,
                    minLines: 1, maxLines: 4,
                    textInputAction: TextInputAction.send,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => controller.send(),
                    decoration: InputDecoration(
                      hintText: t('احكيلي شو بدك…', 'Ask Amar anything…'),
                      filled: true,
                      fillColor: colors.surfaceContainerLow,
                      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(26),
                        borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(26),
                        borderSide: BorderSide(color: colors.primary, width: 1.3)),
                    ),
                  )),
                  const SizedBox(width: 7),
                  IconButton.filledTonal(
                    tooltip: controller.isListening.value
                        ? t('إيقاف الاستماع', 'Stop listening')
                        : t('تحدث', 'Speak'),
                    onPressed: controller.isSending.value || controller.isNavigatingAddress.value
                        ? null : controller.toggleVoice,
                    icon: Icon(controller.isListening.value
                      ? Icons.stop_circle_outlined : Icons.mic_none_rounded),
                  ),
                  const SizedBox(width: 6),
                  IconButton.filled(
                    tooltip: t('إرسال', 'Send'),
                    onPressed: controller.isSending.value ||
                            controller.isNavigatingAddress.value
                        ? null : () => controller.send(),
                    icon: controller.isSending.value
                        ? const SizedBox.square(dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.arrow_upward_rounded),
                  ),
                ]),
                const SizedBox(height: 5),
                Text(t('عَمّار يجهز الطلب، وإنت وحدك بتأكد الشراء والدفع.',
                  'Amar prepares your order. Only you confirm or pay.'),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant, fontSize: 10),
                  textAlign: TextAlign.center),
              ]),
            ),
          ]),
        )),
      );
    });
  }

  void _confirmClear(BuildContext context, bool ar) {
    Get.dialog<void>(AlertDialog(
      title: Text(ar ? 'مسح المحادثة' : 'Clear conversation'),
      content: Text(ar
          ? 'بدك تمسح الرسائل المحفوظة على هذا الجهاز؟'
          : 'Clear the chat history saved on this device?'),
      actions: [
        TextButton(onPressed: () => Get.back<void>(),
          child: Text(ar ? 'إلغاء' : 'Cancel')),
        FilledButton(onPressed: () {
          controller.clearHistory();
          Get.back<void>();
        }, child: Text(ar ? 'مسح' : 'Clear')),
      ],
    ));
  }

  String _errorText(bool ar, String code) {
    String t(String arabic, String english) => ar ? arabic : english;
    if (code.startsWith('unauthenticated')) {
      return t('سجّل الدخول أولاً.', 'Please sign in first.');
    }
    if (code == 'speech_timeout') {
      return t('ما سمعت كلام واضح؛ جرّب الميكروفون مرة ثانية.',
        'No clear speech detected. Please try the microphone again.');
    }
    if (code == 'speech_language_missing') {
      return t('التعرّف على اللغة العربية غير متوفر على الجهاز.',
        'Speech recognition for this language is not installed.');
    }
    if (code == 'speech_wrong_language') {
      return t('التعرّف سمع لغة مختلفة. جرّب مرة ثانية.',
        'Speech was recognized in a different language.');
    }
    if (code == 'speech_voice_missing') {
      return t('الصوت غير مثبت على الجهاز؛ المحادثة المكتوبة بتضل شغالة.',
        'This voice is not installed. Text chat remains available.');
    }
    if (code == 'address_navigation_failed') {
      return t('تعذّر فتح أو تأكيد العنوان المحفوظ.',
        'Unable to open or verify your saved address.');
    }
    if (code == 'form_step_failed') {
      return t('تعذّر إكمال الخطوة؛ جرّب مرة ثانية.',
        'Could not complete the step. Please retry.');
    }
    if (code == 'order_preparation_failed') {
      return t('تعذّر تجهيز الطلب؛ راجع السلة والمنتج.',
        'Could not prepare your order. Check the cart and product.');
    }
    return t('المساعد مش متاح حالياً؛ جرّب مرة ثانية.',
      'Assistant unavailable. Please retry.');
  }

}

class _AmarMark extends StatelessWidget {
  const _AmarMark({this.size = 60});
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.94, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [colors.primary, colors.tertiary]),
          borderRadius: BorderRadius.circular(size * 0.31),
          boxShadow: [BoxShadow(color: colors.primary.withValues(alpha: 0.24),
            blurRadius: 15, offset: const Offset(0, 6))],
        ),
        child: Stack(alignment: Alignment.center, children: [
          Icon(Icons.smart_toy_rounded, size: size * 0.55, color: colors.onPrimary),
          Positioned(right: size * 0.12, top: size * 0.09,
            child: Icon(Icons.auto_awesome_rounded,
              size: size * 0.22, color: Colors.white)),
        ]),
      ),
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel({required this.arabic, required this.onTap,
    required this.onAddress});
  final bool arabic;
  final Future<void> Function(String) onTap;
  final VoidCallback onAddress;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    String t(String ar, String en) => arabic ? ar : en;
    return ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [colors.primaryContainer,
                colors.surfaceContainerHigh]),
            border: Border.all(color: colors.primary.withValues(alpha: 0.12)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _AmarMark(size: 68),
            const SizedBox(height: 22),
            Text(t('أهلاً، أنا عَمّار ✨', 'Hey there, I’m Amar ✨'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colors.onSurface, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(t('احكيلي بطريقتك! بدورلك على منتجات وخدمات حقيقية، وبمشي معك بالطلب خطوة بخطوة.',
              'Tell me what you need. I can find real products and services and guide you through checkout.'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.55, color: colors.onSurfaceVariant)),
          ]),
        ),
        const SizedBox(height: 24),
        Text(t('كيف بقدر أساعدك اليوم؟', 'What can I help you with?'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        _QuickTile(icon: Icons.shopping_bag_outlined,
          title: t('اطلب منتج', 'Order a product'),
          subtitle: t('ابحث عن المنتجات والأسعار', 'Browse real products and prices'),
          onTap: () => onTap(t('بدي أطلب قاطع كهربائي عدد 2', 'I want to order 2 electrical circuit breakers'))),
        const SizedBox(height: 9),
        _QuickTile(icon: Icons.handyman_outlined,
          title: t('اطلب خدمة', 'Book a service'),
          subtitle: t('سباكة، كهرباء، صيانة…', 'Plumbing, electrical, repairs…'),
          onTap: () => onTap(t('بدي أطلب خدمة سباك', 'I want to book a plumber'))),
        const SizedBox(height: 9),
        _QuickTile(icon: Icons.location_on_outlined,
          title: t('عنوان التوصيل', 'Delivery address'),
          subtitle: t('اختار عنوان محفوظ أو حدّد على الخريطة',
            'Choose a saved address or a map location'),
          onTap: onAddress),
        const SizedBox(height: 9),
        _QuickTile(icon: Icons.forum_outlined,
          title: t('اسألني أي سؤال', 'Chat with me'),
          subtitle: t('نصائح واقتراحات لمشروعك', 'Advice and ideas for your project'),
          onTap: () => onTap(t('مرحبا عَمّار، كيف بتساعدني؟',
            'Hi Amar, what can you help me with?'))),
      ],
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({required this.icon, required this.title,
    required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18),
        child: Padding(padding: const EdgeInsets.all(13),
          child: Row(children: [
            CircleAvatar(backgroundColor: colors.primaryContainer,
              child: Icon(icon, color: colors.primary)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold)),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              ])),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, size: 15,
              color: colors.onSurfaceVariant),
          ])),
      ),
    );
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
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(19),
                  topRight: const Radius.circular(19),
                  bottomLeft: Radius.circular(message.isUser ? 19 : 6),
                  bottomRight: Radius.circular(message.isUser ? 6 : 19),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!message.isUser)
                    Padding(padding: const EdgeInsets.only(bottom: 6),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.auto_awesome_rounded,
                          size: 14, color: colors.primary),
                        const SizedBox(width: 5),
                        Text('AMAR AI', style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(fontWeight: FontWeight.w800,
                            color: colors.primary, letterSpacing: 0.4)),
                      ])),
                  Text(message.text, style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(height: 1.55)),
                  if (!message.isUser && message.text.trim().isNotEmpty)
                    Align(alignment: AlignmentDirectional.centerEnd,
                      child: IconButton(
                        tooltip: chat.chatLanguage.value == 'en'
                            ? 'Read aloud' : 'اسمع الرد',
                        constraints: const BoxConstraints(minHeight: 30, minWidth: 34),
                        icon: Icon(Icons.volume_up_outlined,
                          color: colors.primary, size: 18),
                        onPressed: () => chat.speakMessage(message.text),
                      )),
                ],
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
                                    chat.chatLanguage.value == 'en'
                                        ? 'Store: ${item.vendorName}'
                                        : 'المتجر: ${item.vendorName}',
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
                                   Text(
                                    chat.chatLanguage.value == 'en' ? 'Open now' : 'مفتوح الآن',
                                    style: const TextStyle(
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
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(chat.chatLanguage.value == 'en'
                                    ? 'Order' : 'اختار للطلب'),
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
