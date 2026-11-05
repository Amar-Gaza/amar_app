import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/driver/driver_order_controller.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/localization/error_message_resolver.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/auth/otp_input.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/checkout/label_value_row.dart';
import '../../widgets/checkout/payment_label.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/common/dot_pill.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/info_banner.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_tone.dart';
import '../../widgets/driver/cash_tag.dart';
import '../../widgets/driver/contact_row.dart';
import '../../widgets/driver/delivered_panel.dart';
import '../../widgets/driver/driver_card_footer.dart';
import '../../widgets/driver/job_map.dart';
import '../../widgets/driver/job_top_bar.dart';
import '../../widgets/driver/order_card_header.dart';
import '../../widgets/driver/proof_photo_button.dart';
import '../../widgets/driver/route_steps.dart';
import '../../widgets/driver/stage_bar.dart';
import '../../widgets/orders/section_card.dart';

/// One job from offer to delivery: map on top, a draggable sheet with the
/// contact, stage, route and the inputs the next action needs (10–22).
class DriverOrderScreen extends GetView<DriverOrderController> {
  const DriverOrderScreen({super.key});

  static const double _sheetMin = 0.64;
  static const double _sheetMax = 0.94;
  static const double _handleWidth = 42;
  static const double _handleHeight = 5;

  /// Driver-side stages shown as the segmented bar.
  static const List<String> _stages = [
    StatusKeys.accepted,
    StatusKeys.pickedUp,
    StatusKeys.onTheWay,
    StatusKeys.arrived,
    StatusKeys.delivered,
  ];

  Future<void> _runNext(BuildContext context) async {
    final next = controller.next;
    if (next == null) return;
    // Required inputs are filled on the sheet itself, so they act as the
    // confirmation; plain transitions still ask first.
    if (!controller.hasInputs) {
      final message = next.confirm ??
          AppLocalizations.of(context).driverActionConfirm(next.label);
      if (!await ConfirmationDialog.show(context, message)) return;
    }
    await controller.runNext();
  }

  Future<void> _reject(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    if (!await ConfirmationDialog.show(context, l10n.driverRejectConfirm)) {
      return;
    }
    if (await controller.reject()) Get.back<void>();
  }

  Future<void> _pickPhoto() async {
    final picked = await pickProofPhoto();
    if (picked != null) controller.photoPath.value = picked;
  }

  String? _hint(AppLocalizations l10n, String key) => switch (key) {
        StatusKeys.accepted => l10n.driverHintAccepted,
        StatusKeys.pickedUp => l10n.driverHintPickedUp,
        StatusKeys.onTheWay => l10n.driverHintOnTheWay,
        StatusKeys.arrived => l10n.driverHintArrived,
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Obx(() {
      final order = controller.order.value;
      final failure = controller.failure.value;
      if (order == null) {
        return Scaffold(
          appBar: AppTopBar(title: l10n.driverOrderTitle),
          body: failure != null
              ? ErrorView(failure: failure, onRetry: controller.load)
              : const LoadingView(),
        );
      }
      final delivered = controller.delivered.value;
      final next = controller.next;
      final isOffer = !order.isMine;
      final stage = _stages.indexOf(order.status.key);
      final hint = _hint(l10n, order.status.key);
      final collect = order.payment.collect;
      final mapHeight =
          MediaQuery.sizeOf(context).height * (1 - _sheetMin) + AppRadius.xl;
      final failureBanner = failure == null
          ? null
          : InfoBanner(
              title: failure.code == ApiErrorCodes.alreadyTaken
                  ? l10n.driverAlreadyTaken
                  : l10n.commonErrorTitle,
              message: ErrorMessageResolver.resolve(failure, l10n),
            );
      final details = SectionCard(
        title: l10n.driverOrderDetails,
        children: [
          for (final item in order.items)
            LabelValueRow(label: item.name, value: '× ${item.qty}'),
          if (order.items.isEmpty && order.itemsCount != null)
            Text(l10n.orderItemsCount(order.itemsCount!)),
          LabelValueRow(
            label: l10n.checkoutPayment,
            value: paymentLabel(l10n, order.payment.method),
          ),
          LabelValueRow(label: l10n.driverCollect, value: collect.formatted),
          LabelValueRow(
            label: l10n.quoteDeliveryFee,
            value: order.deliveryFee.formatted,
          ),
          LabelValueRow(
            label: l10n.quoteDistance,
            value: l10n.vendorDistance(order.distanceKm.toStringAsFixed(1)),
          ),
        ],
      );
      return Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: mapHeight,
              child: JobMap(pickup: order.pickup, dropoff: order.dropoff),
            ),
            JobTopBar(
              title: l10n.orderCode(order.code),
              onBack: () => Get.back<void>(),
            ),
            DraggableScrollableSheet(
              initialChildSize: _sheetMin,
              minChildSize: _sheetMin,
              maxChildSize: _sheetMax,
              builder: (context, scroll) => DecoratedBox(
                decoration: BoxDecoration(
                  color: context.scheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.xl),
                  ),
                  boxShadow: AppShadows.hero(colors),
                ),
                child: RefreshIndicator(
                  onRefresh: controller.load,
                  child: ListView(
                    controller: scroll,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.page,
                      AppSpacing.sm,
                      AppSpacing.page,
                      AppSpacing.xl,
                    ),
                    children: [
                      Center(
                        child: Container(
                          width: _handleWidth,
                          height: _handleHeight,
                          decoration: BoxDecoration(
                            color: colors.border,
                            borderRadius: AppRadius.pillAll,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (delivered)
                        DeliveredPanel(
                          earning: order.earning.formatted,
                          onDone: () => Get.back<void>(),
                        )
                      else if (isOffer) ...[
                        OrderCardHeader(
                          icon: LucideIcons.shoppingBag,
                          title: l10n.orderCode(order.code),
                          subtitle: l10n.vendorDistance(
                            (order.distanceToPickupKm ?? order.distanceKm)
                                .toStringAsFixed(1),
                          ),
                          trailing: DotPill(label: l10n.driverNewBadge),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        RouteSteps(order: order),
                        const SizedBox(height: AppSpacing.md),
                        DriverCardFooter(
                          label: l10n.driverYourFee,
                          value: order.earning.formatted,
                          trailing: [
                            if (collect.amount > 0)
                              CashTag(
                                label: l10n.driverCashAmount(collect.formatted),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (failureBanner != null) ...[
                          failureBanner,
                          const SizedBox(height: AppSpacing.md),
                        ],
                        details,
                      ] else ...[
                        if (order.customer != null) ...[
                          ContactRow(
                            name: order.customer!.name ?? l10n.driverCustomer,
                            subtitle: l10n.driverContactSubtitle(
                              l10n.driverCustomer,
                              l10n.orderCode(order.code),
                            ),
                            phone: order.customer!.phone,
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        if (order.vendor?.phone != null) ...[
                          ContactRow(
                            name: order.vendor!.name,
                            subtitle: l10n.driverStore,
                            phone: order.vendor!.phone,
                            imageUrl: order.vendor!.logoUrl,
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        if (stage >= 0) ...[
                          const SizedBox(height: AppSpacing.xs),
                          StageBar(count: _stages.length, current: stage),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        Text(
                          order.status.label,
                          style: context.text.headlineSmall
                              ?.copyWith(color: colors.brand),
                        ),
                        if (hint != null)
                          Text(hint, style: context.text.bodySmall),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: context.scheme.surface,
                            borderRadius: AppRadius.sheetAll,
                            border: Border.all(color: colors.border),
                            boxShadow: AppShadows.card(colors),
                          ),
                          child: RouteSteps(order: order, showDirections: true),
                        ),
                        if (failureBanner != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          failureBanner,
                        ],
                        if (next != null && controller.needsPhoto) ...[
                          const SizedBox(height: AppSpacing.md),
                          ProofPhotoButton(
                            path: controller.photoPath.value,
                            onTap: _pickPhoto,
                          ),
                        ],
                        if (next != null && controller.needsOtp) ...[
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            l10n.driverAskCode,
                            style: context.text.bodySmall,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: controller.otp,
                            builder: (_, value, __) => OtpInput(
                              controller: controller.otp,
                              length: AppDefaults.deliveryOtpLength,
                              value: value.text,
                              hasError: false,
                              onChanged: (_) {},
                            ),
                          ),
                        ],
                        if (next != null && controller.hasInputs) ...[
                          const SizedBox(height: AppSpacing.md),
                          for (final key in next.fields)
                            AppTextField(
                              controller: controller.field(key),
                              label: key,
                              hint: key,
                            ),
                          AppTextField(
                            controller: controller.note,
                            label: l10n.detailsNote,
                            hint: l10n.detailsNoteHint,
                          ),
                        ],
                        if (order.note != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          InfoBanner(
                            icon: LucideIcons.messageSquare,
                            tone: StateTone.info,
                            title: order.note!,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        details,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: delivered || (next == null && !isOffer)
            ? null
            : BottomActionBar(
                child: Row(
                  children: [
                    if (next != null)
                      Expanded(
                        child: PrimaryButton(
                          label: next.label,
                          isLoading: controller.isBusy.value,
                          onPressed: controller.needsPhoto &&
                                  controller.photoPath.value == null
                              ? null
                              : () => _runNext(context),
                        ),
                      ),
                    if (isOffer) ...[
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize:
                                const Size.fromHeight(AppSizes.buttonHeight),
                            foregroundColor: colors.danger,
                            side: BorderSide(color: colors.danger),
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadius.buttonAll,
                            ),
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
