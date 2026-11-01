import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/customer/order_details_controller.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/checkout/label_value_row.dart';
import '../../widgets/checkout/payment_label.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/icon_tile.dart';
import '../../widgets/common/info_banner.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_tone.dart';
import '../../widgets/orders/person_card.dart';
import '../../widgets/orders/route_card.dart';
import '../../widgets/orders/section_card.dart';
import '../../widgets/orders/status_chip.dart';
import '../../widgets/orders/status_progress.dart';
import '../../widgets/orders/timeline_list.dart';

/// Order details and timeline (designs 05, 06).
class OrderDetailsScreen extends GetView<OrderDetailsController> {
  const OrderDetailsScreen({super.key});

  Future<void> _open(String route) async {
    await Get.toNamed<void>(route, arguments: controller.orderId);
    await controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final locale = Localizations.localeOf(context).languageCode;
    return Obx(() {
      final order = controller.order.value;
      final failure = controller.failure.value;
      if (order == null) {
        return Scaffold(
          appBar: AppTopBar(title: l10n.orderDetailsTitle),
          body: failure != null
              ? ErrorView(failure: failure, onRetry: controller.load)
              : const LoadingView(),
        );
      }
      final cancel = controller.action(OrderActions.cancel);
      return Scaffold(
        appBar: AppTopBar(
          title: l10n.orderDetailsTitle,
          trailing: PopupMenuButton<String>(
            icon: const Icon(LucideIcons.ellipsisVertical),
            onSelected: _open,
            itemBuilder: (_) => [
              PopupMenuItem(
                value: AppRoutes.orderReceipt,
                child: Text(l10n.receiptTitle),
              ),
              PopupMenuItem(
                value: AppRoutes.orderShare,
                child: Text(l10n.shareTitle),
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.successOrderNumber,
                          style: context.text.labelSmall
                              ?.copyWith(color: colors.mutedText),
                        ),
                        Text(
                          order.code,
                          textDirection: TextDirection.ltr,
                          style: context.text.headlineSmall,
                        ),
                        Text(
                          DateFormatter.dayMonthTime(order.createdAt, locale),
                          style: context.text.labelSmall
                              ?.copyWith(color: colors.mutedText),
                        ),
                      ],
                    ),
                  ),
                  StatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (!order.status.isTerminal)
                StatusProgress(
                  step: order.status.step,
                  total: controller.lastStep,
                ),
              const SizedBox(height: AppSpacing.md),
              if (controller.hasOffer) ...[
                InkWell(
                  onTap: () => _open(AppRoutes.orderOffer),
                  child: InfoBanner(
                    icon: LucideIcons.receiptText,
                    tone: StateTone.warning,
                    title: l10n.offerPendingTitle,
                    message: l10n.offerPendingMessage,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (order.cancelReason != null) ...[
                InfoBanner(
                  title: l10n.orderCancelledTitle,
                  message: order.cancelReason,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              SectionCard(
                title: l10n.reviewProducts,
                trailing: Text(
                  l10n.orderItemsCount(order.items.length),
                  style: context.text.labelSmall,
                ),
                children: [
                  for (final item in order.items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Row(
                        children: [
                          const IconTile(
                            icon: LucideIcons.package,
                            size: AppSizes.iconTileSm,
                            iconSize: AppSizes.iconSm,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: context.text.titleSmall),
                                Text(
                                  l10n.cartQty(item.qty),
                                  style: context.text.labelSmall,
                                ),
                              ],
                            ),
                          ),
                          if (item.lineTotal != null)
                            Text(
                              item.lineTotal!.formatted,
                              style: context.text.labelMedium,
                            ),
                        ],
                      ),
                    ),
                ],
              ),
              RouteCard(
                pickup: order.pickup,
                dropoff: order.dropoff,
                pickupName: order.vendor?.name,
              ),
              if (order.driver != null) ...[
                PersonCard(
                  name: order.driver!.name,
                  subtitle: l10n.trackingDriverRating(
                    order.driver!.rating.average.toStringAsFixed(1),
                  ),
                  phone: order.driver!.phone,
                  avatarUrl: order.driver!.avatarUrl,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              SectionCard(
                children: [
                  LabelValueRow(
                    label: l10n.quoteItemsTotal,
                    value: order.price.itemsTotal.formatted,
                  ),
                  LabelValueRow(
                    label: l10n.quoteDeliveryFee,
                    value: order.price.deliveryFee.formatted,
                  ),
                  if (order.price.discount.amount != 0)
                    LabelValueRow(
                      label: l10n.quoteDiscount,
                      value: order.price.discount.formatted,
                    ),
                  const Divider(),
                  LabelValueRow(
                    label: l10n.quoteTotal,
                    value: order.price.total.formatted,
                    valueStyle:
                        context.text.titleLarge?.copyWith(color: colors.brand),
                  ),
                  LabelValueRow(
                    label: l10n.checkoutPayment,
                    value: paymentLabel(l10n, order.payment.method),
                  ),
                  if (order.scheduledFor != null)
                    LabelValueRow(
                      label: l10n.deliveryTime,
                      value: DateFormatter.dayMonthTime(
                        order.scheduledFor!,
                        locale,
                      ),
                    ),
                  if (order.deliveryCode != null)
                    LabelValueRow(
                      label: l10n.orderDeliveryCode,
                      value: order.deliveryCode!,
                      ltrValue: true,
                    ),
                ],
              ),
              if (order.attachments.isNotEmpty)
                SectionCard(
                  title: l10n.attachTitle,
                  children: [
                    Text(
                      l10n.detailsAttachedCount(order.attachments.length),
                      style: context.text.bodySmall,
                    ),
                  ],
                ),
              if (order.timeline.isNotEmpty)
                SectionCard(
                  title: l10n.orderTimelineTitle,
                  children: [TimelineList(entries: order.timeline)],
                ),
            ],
          ),
        ),
        bottomNavigationBar: _actions(context, cancel != null),
      );
    });
  }

  Widget? _actions(BuildContext context, bool canCancel) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final buttons = <Widget>[
      if (controller.hasOffer)
        Expanded(
          child: PrimaryButton(
            label: l10n.offerView,
            onPressed: () => _open(AppRoutes.orderOffer),
          ),
        )
      else if (controller.can(OrderActions.track))
        Expanded(
          child: PrimaryButton(
            label: l10n.successTrack,
            onPressed: () => _open(AppRoutes.orderTracking),
          ),
        ),
      if (controller.can(OrderActions.rate))
        Expanded(
          child: PrimaryButton(
            label: l10n.rateTitle,
            onPressed: () => _open(AppRoutes.orderRate),
          ),
        ),
      if (canCancel)
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.danger,
              side: BorderSide(color: colors.danger),
            ),
            onPressed: () => _open(AppRoutes.orderCancel),
            child: Text(l10n.cancelOrder),
          ),
        ),
    ];
    if (buttons.isEmpty) return null;
    return BottomActionBar(
      child: Row(
        children: [
          for (var i = 0; i < buttons.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.md),
            buttons[i],
          ],
        ],
      ),
    );
  }
}
