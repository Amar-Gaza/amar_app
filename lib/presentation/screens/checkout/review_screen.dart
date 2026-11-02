import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/customer/cart_controller.dart';
import '../../../controllers/customer/checkout_controller.dart';
import '../../../core/localization/error_message_resolver.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/checkout/cart_line_card.dart';
import '../../widgets/checkout/checkout_steps.dart';
import '../../widgets/checkout/label_value_row.dart';
import '../../widgets/checkout/payment_label.dart';
import '../../widgets/checkout/price_card.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/info_banner.dart';
import '../../widgets/common/primary_button.dart';
import 'placing_order_view.dart';
import 'quote_expired_view.dart';

/// Final review, submission and failure (designs 14, 15, 17).
class ReviewScreen extends GetView<CheckoutController> {
  const ReviewScreen({super.key});

  Widget _section(BuildContext context, String title, List<Widget> children) =>
      Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: context.appColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: context.text.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            ...children,
          ],
        ),
      );

  Future<void> _submit() async {
    if (!await controller.placeOrder()) return;
    await Get.offNamedUntil<void>(
      AppRoutes.checkoutSuccess,
      (route) => route.settings.name == AppRoutes.home,
      arguments: controller.placedOrder.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cart = Get.find<CartController>();
    return Obx(() {
      final quote = controller.quote.value;
      if (controller.isPlacing.value) {
        return const Scaffold(body: SafeArea(child: PlacingOrderView()));
      }
      if (quote == null || controller.quoteNeedsRefresh) {
        return Scaffold(
          appBar: AppTopBar(title: l10n.reviewTitle),
          body: const QuoteExpiredView(),
        );
      }
      final failure = controller.placeFailure.value;
      final address = controller.address.value;
      return Scaffold(
        appBar: AppTopBar(title: l10n.reviewTitle),
        body: Column(
          children: [
            const CheckoutSteps(current: 3),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  if (failure != null) ...[
                    InfoBanner(
                      title: l10n.placeFailedTitle,
                      message: ErrorMessageResolver.resolve(failure, l10n),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  _section(context, l10n.reviewProducts, [
                    for (final item in cart.checkoutItems) ...[
                      CartLineCard(item: item),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ]),
                  _section(context, l10n.reviewDeliveryPayment, [
                    LabelValueRow(
                      icon: LucideIcons.house,
                      label: l10n.deliveryAddress,
                      value: address?.label ?? '',
                    ),
                    LabelValueRow(
                      icon: LucideIcons.banknote,
                      label: l10n.checkoutPayment,
                      value: paymentLabel(l10n, quote.paymentMethod),
                    ),
                    if (controller.attachments.any((a) => a.isDone))
                      LabelValueRow(
                        icon: LucideIcons.paperclip,
                        label: l10n.attachTitle,
                        value: l10n.detailsAttachedCount(
                          controller.attachments.where((a) => a.isDone).length,
                        ),
                      ),
                  ]),
                  PriceCard(
                    quote: quote,
                    secondsLeft: controller.quoteSecondsLeft.value,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomActionBar(
          child: PrimaryButton(
            label: failure == null
                ? l10n.reviewConfirm(quote.total.formatted)
                : l10n.commonRetry,
            onPressed: _submit,
          ),
        ),
      );
    });
  }
}
