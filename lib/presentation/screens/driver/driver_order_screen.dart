import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/driver/driver_order_controller.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/localization/error_message_resolver.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/checkout/label_value_row.dart';
import '../../widgets/checkout/payment_label.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/icon_tile.dart';
import '../../widgets/common/info_banner.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_tone.dart';
import '../../widgets/common/state_view.dart';
import '../../widgets/orders/person_card.dart';
import '../../widgets/orders/route_card.dart';
import '../../widgets/orders/section_card.dart';
import 'driver_action_sheet.dart';

/// One job from offer to delivery (designs 10–22).
class DriverOrderScreen extends GetView<DriverOrderController> {
  const DriverOrderScreen({super.key});

  Future<void> _runNext(BuildContext context) async {
    final next = controller.next;
    if (next == null) return;
    if (controller.hasInputs) {
      await DriverActionSheet.show(context);
      return;
    }
    final message = next.confirm ??
        AppLocalizations.of(context).driverActionConfirm(next.label);
    if (!await ConfirmationDialog.show(context, message)) return;
    await controller.runNext();
  }

  Future<void> _reject(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    if (!await ConfirmationDialog.show(context, l10n.driverRejectConfirm)) {
      return;
    }
    if (await controller.reject()) Get.back<void>();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Obx(() {
      final order = controller.order.value;
      final failure = controller.failure.value;
      if (controller.delivered.value) {
        return Scaffold(
          body: SafeArea(
            child: StateView(
              icon: LucideIcons.circleCheck,
              tone: StateTone.success,
              title: l10n.driverDeliveredTitle,
              message: order == null
                  ? null
                  : l10n.driverDeliveredMessage(order.earning.formatted),
              primaryLabel: l10n.successBackHome,
              onPrimary: () => Get.back<void>(),
            ),
          ),
        );
      }
      if (order == null) {
        return Scaffold(
          appBar: AppTopBar(title: l10n.driverOrderTitle),
          body: failure != null
              ? ErrorView(failure: failure, onRetry: controller.load)
              : const LoadingView(),
        );
      }
      final next = controller.next;
      final isOffer = !order.isMine;
      return Scaffold(
        appBar: AppTopBar(
            title: isOffer ? l10n.driverOrderTitle : l10n.driverCurrentTask),
        body: RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.ink,
                  borderRadius: AppRadius.lgAll,
                ),
                child: Row(
                  children: [
                    IconTile(
                      icon: LucideIcons.truck,
                      background: colors.onInk.withValues(alpha: 0.12),
                      foreground: colors.accent,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.code,
                            textDirection: TextDirection.ltr,
                            style: context.text.labelSmall
                                ?.copyWith(color: colors.accent),
                          ),
                          Text(
                            order.status.label,
                            style: context.text.titleLarge
                                ?.copyWith(color: colors.onInk),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      order.earning.formatted,
                      style: context.text.titleMedium
                          ?.copyWith(color: colors.accent),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (failure != null) ...[
                InfoBanner(
                  title: failure.code == ApiErrorCodes.alreadyTaken
                      ? l10n.driverAlreadyTaken
                      : l10n.commonErrorTitle,
                  message: ErrorMessageResolver.resolve(failure, l10n),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              RouteCard(
                pickup: order.pickup,
                dropoff: order.dropoff,
                pickupName: order.vendor?.name,
                showDirections: order.isMine,
              ),
              if (order.isMine && order.customer != null) ...[
                PersonCard(
                  name: order.customer!.name ?? l10n.driverCustomer,
                  subtitle: l10n.driverCustomer,
                  phone: order.customer!.phone,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (order.isMine && order.vendor?.phone != null) ...[
                PersonCard(
                  name: order.vendor!.name,
                  subtitle: l10n.productVendor,
                  phone: order.vendor!.phone,
                  avatarUrl: order.vendor!.logoUrl,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              SectionCard(
                title: l10n.reviewProducts,
                children: [
                  for (final item in order.items)
                    LabelValueRow(label: item.name, value: '× ${item.qty}'),
                  if (order.items.isEmpty && order.itemsCount != null)
                    Text(l10n.orderItemsCount(order.itemsCount!)),
                ],
              ),
              SectionCard(
                children: [
                  LabelValueRow(
                    label: l10n.checkoutPayment,
                    value: paymentLabel(l10n, order.payment.method),
                  ),
                  LabelValueRow(
                    label: l10n.driverCollect,
                    value: order.payment.collect.formatted,
                  ),
                  LabelValueRow(
                    label: l10n.quoteDeliveryFee,
                    value: order.deliveryFee.formatted,
                  ),
                  LabelValueRow(
                    label: l10n.quoteDistance,
                    value: l10n
                        .vendorDistance(order.distanceKm.toStringAsFixed(1)),
                  ),
                ],
              ),
              if (order.note != null)
                InfoBanner(
                  icon: LucideIcons.messageSquare,
                  tone: StateTone.info,
                  title: order.note!,
                ),
            ],
          ),
        ),
        bottomNavigationBar: next == null && !isOffer
            ? null
            : BottomActionBar(
                child: Row(
                  children: [
                    if (next != null)
                      Expanded(
                        child: PrimaryButton(
                          label: next.label,
                          isLoading: controller.isBusy.value,
                          onPressed: () => _runNext(context),
                        ),
                      ),
                    if (isOffer) ...[
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colors.danger,
                            side: BorderSide(color: colors.danger),
                          ),
                          onPressed: controller.isBusy.value
                              ? null
                              : () => _reject(context),
                          child: Text(l10n.driverReject),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      );
    });
  }
}

/// Picks a proof photo with the camera.
Future<String?> pickProofPhoto() async {
  final file = await ImagePicker().pickImage(
    source: ImageSource.camera,
    imageQuality: AppDefaults.imageQuality,
  );
  return file?.path;
}

/// Square used for photo previews in the action sheet.
const double proofPreview = AppSizes.productImage;
