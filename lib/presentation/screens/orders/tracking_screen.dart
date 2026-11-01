import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/customer/tracking_controller.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/launcher.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/label_value_row.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/empty_view.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/skeleton_list.dart';
import '../../widgets/orders/person_card.dart';
import '../../widgets/orders/status_chip.dart';

/// Live tracking (designs 12, 13, 17A–C).
class TrackingScreen extends GetView<TrackingController> {
  const TrackingScreen({super.key});

  static const double _mapHeight = 220;
  static const int _coordDigits = 4;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Scaffold(
      appBar: AppTopBar(
        title: l10n.successTrack,
        trailing: IconButton(
          tooltip: l10n.shareTitle,
          onPressed: () => Get.toNamed<void>(
            AppRoutes.orderShare,
            arguments: controller.orderId,
          ),
          icon: const Icon(LucideIcons.share2),
        ),
      ),
      body: Obx(() {
        final data = controller.tracking.value;
        final failure = controller.failure.value;
        if (controller.isLoading.value) {
          return const SkeletonList(showSearch: false, rows: 2);
        }
        if (data == null) {
          return failure != null
              ? ErrorView(failure: failure, onRetry: controller.refreshNow)
              : EmptyView(
                  icon: LucideIcons.mapPin,
                  title: l10n.trackingEmptyTitle,
                  message: l10n.trackingEmptyMessage,
                );
        }
        final driver = data.driver;
        final location = driver?.location;
        return RefreshIndicator(
          onRefresh: controller.refreshNow,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Container(
                height: _mapHeight,
                decoration: BoxDecoration(
                  color: colors.surfaceSoft,
                  borderRadius: AppRadius.lgAll,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: AppSizes.iconTileSm / 2,
                      backgroundColor: colors.brand,
                      child: Icon(LucideIcons.truck, color: colors.onBrand),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      location == null
                          ? l10n.trackingNoLocation
                          : '${location.lat.toStringAsFixed(_coordDigits)}, '
                              '${location.lng.toStringAsFixed(_coordDigits)}',
                      textDirection: TextDirection.ltr,
                      style: context.text.labelMedium,
                    ),
                    if (location != null)
                      TextButton.icon(
                        onPressed: () =>
                            Launcher.map(location.lat, location.lng),
                        icon: const Icon(LucideIcons.map),
                        label: Text(l10n.trackingOpenMap),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.status.label,
                          style: context.text.labelSmall
                              ?.copyWith(color: colors.brand),
                        ),
                        Text(
                          data.etaMinutes == null
                              ? data.status.label
                              : l10n.trackingEta(data.etaMinutes!),
                          style: context.text.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  StatusChip(status: data.status),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              if (driver != null)
                PersonCard(
                  name: driver.name,
                  subtitle:
                      '${driver.vehicleType} · ${l10n.trackingDriverRating(driver.rating.average.toStringAsFixed(1))}',
                  phone: driver.phone,
                  avatarUrl: driver.avatarUrl,
                )
              else
                Text(l10n.trackingNoDriver, style: context.text.bodySmall),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.surfaceSoft,
                  borderRadius: AppRadius.lgAll,
                ),
                child: LabelValueRow(
                  icon: LucideIcons.clock,
                  label: l10n.trackingNextUpdate,
                  value: l10n.trackingSeconds(controller.nextPoll.value),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
