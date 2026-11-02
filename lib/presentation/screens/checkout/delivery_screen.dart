import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/customer/checkout_controller.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../data/models/catalog/payment_option.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/checkout/checkout_row.dart';
import '../../widgets/checkout/checkout_steps.dart';
import '../../widgets/checkout/payment_label.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/primary_button.dart';

/// Pickup, drop-off, time, payment, details and coupon (design 04).
class DeliveryScreen extends GetView<CheckoutController> {
  const DeliveryScreen({super.key});

  Future<void> _pickSchedule(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    // Scheduled work starts from the next day; a service must be scheduled.
    final firstDay = DateTime(now.year, now.month, now.day + 1);
    if (!controller.isService) {
      final asap = await showModalBottomSheet<bool>(
        context: context,
        builder: (sheet) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(LucideIcons.zap),
                title: Text(l10n.scheduleNow),
                onTap: () => Navigator.of(sheet).pop(true),
              ),
              ListTile(
                leading: const Icon(LucideIcons.calendarClock),
                title: Text(l10n.schedulePick),
                onTap: () => Navigator.of(sheet).pop(false),
              ),
            ],
          ),
        ),
      );
      if (asap == null) return;
      if (asap) {
        controller.setSchedule(null);
        return;
      }
    }
    if (!context.mounted) return;
    final day = await showDatePicker(
      context: context,
      firstDate: firstDay,
      lastDate:
          firstDay.add(const Duration(days: AppDefaults.scheduleDaysAhead)),
    );
    if (day == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (time == null) return;
    controller.setSchedule(
      DateTime(day.year, day.month, day.day, time.hour, time.minute),
    );
  }

  Future<void> _pickPayment(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final picked = await showModalBottomSheet<PaymentOption>(
      context: context,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final option in controller.paymentOptions)
              ListTile(
                title: Text(
                  option.gateway?.name ?? paymentLabel(l10n, option.method),
                ),
                trailing: option.same(controller.payment)
                    ? const Icon(LucideIcons.check)
                    : null,
                onTap: () => Navigator.of(sheet).pop(option),
              ),
          ],
        ),
      ),
    );
    if (picked != null) controller.setPayment(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppTopBar(title: l10n.deliveryTitle),
      body: Column(
        children: [
          const CheckoutSteps(current: 1),
          Expanded(
            child: Obx(() {
              final address = controller.address.value;
              final schedule = controller.scheduledFor.value;
              final failure = controller.quoteFailure.value;
              final uploaded =
                  controller.attachments.where((a) => a.isDone).length;
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  CheckoutRow(
                    icon: LucideIcons.store,
                    title: l10n.deliveryPickup,
                    value: controller.vendor.value?.name ??
                        l10n.cartVendorFallback,
                  ),
                  CheckoutRow(
                    icon: LucideIcons.mapPin,
                    title: l10n.deliveryAddress,
                    value: address == null
                        ? l10n.deliveryChooseAddress
                        : [address.label, address.details]
                            .whereType<String>()
                            .join(' · '),
                    highlight: address == null,
                    onTap: () => Get.toNamed<void>(AppRoutes.checkoutAddresses),
                  ),
                  CheckoutRow(
                    icon: LucideIcons.calendarClock,
                    title: l10n.deliveryTime,
                    value: schedule == null
                        ? controller.isService
                            ? l10n.scheduleChoose
                            : l10n.scheduleNow
                        : DateFormatter.dayMonthTime(schedule, locale),
                    onTap: () => _pickSchedule(context),
                  ),
                  if (controller.paymentOptions.isNotEmpty)
                    CheckoutRow(
                      icon: LucideIcons.banknote,
                      title: l10n.checkoutPayment,
                      value: controller.gateway.value?.name ??
                          paymentLabel(l10n, controller.paymentMethod.value),
                      onTap: controller.paymentOptions.length > 1
                          ? () => _pickPayment(context)
                          : null,
                    ),
                  CheckoutRow(
                    icon: LucideIcons.fileText,
                    title: l10n.detailsTitle,
                    value: uploaded == 0
                        ? l10n.detailsHint
                        : l10n.detailsAttachedCount(uploaded),
                    onTap: () => Get.toNamed<void>(AppRoutes.checkoutDetails),
                  ),
                  if (controller.couponsEnabled)
                    CheckoutRow(
                      icon: LucideIcons.ticket,
                      title: l10n.couponTitle,
                      value: controller.coupon.value ?? l10n.couponHint,
                      onTap: () => Get.toNamed<void>(AppRoutes.checkoutCoupon),
                    ),
                  if (failure != null) ErrorBanner(failure: failure),
                ],
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: Obx(
          () => PrimaryButton(
            label: controller.address.value == null
                ? l10n.deliveryChooseAddress
                : l10n.deliveryRequestQuote,
            isLoading: controller.isQuoting.value,
            onPressed: controller.address.value == null
                ? () => Get.toNamed<void>(AppRoutes.checkoutAddresses)
                : controller.canRequestQuote
                    ? () async {
                        if (await controller.requestQuote()) {
                          await Get.toNamed<void>(AppRoutes.checkoutQuote);
                        }
                      }
                    : null,
          ),
        ),
      ),
    );
  }
}
