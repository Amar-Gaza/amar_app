import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/driver/driver_home_controller.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/common/avatar_initial.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/driver/driver_order_card.dart';
import '../../widgets/driver/location_status_card.dart';
import '../../widgets/driver/stat_tile.dart';

/// Dashboard (designs 04, 05).
class DriverHomeTab extends GetView<DriverHomeController> {
  const DriverHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Obx(() {
      final driver = controller.driver;
      final online = controller.isOnline;
      final current = controller.current.value;
      final today = controller.today.value;
      final failure = controller.failure.value;
      return RefreshIndicator(
        onRefresh: controller.refreshAll,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: colors.ink,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      AvatarInitial(
                        name: driver?.name,
                        imageUrl: driver?.avatarUrl,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.driverGreeting,
                              style: context.text.labelSmall
                                  ?.copyWith(color: colors.accent),
                            ),
                            Text(
                              driver?.name ?? '',
                              style: context.text.titleLarge
                                  ?.copyWith(color: colors.onInk),
                            ),
                          ],
                        ),
                      ),
                      IconButton.outlined(
                        onPressed: () =>
                            Get.toNamed<void>(AppRoutes.driverNotifications),
                        style: IconButton.styleFrom(
                          side: BorderSide(color: colors.onInk),
                        ),
                        icon: Icon(LucideIcons.bell, color: colors.onInk),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: context.scheme.surface,
                      borderRadius: AppRadius.lgAll,
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: AppSpacing.sm,
                                    color: online
                                        ? colors.success
                                        : colors.subtleText,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    online
                                        ? l10n.driverOnline
                                        : l10n.driverOffline,
                                    style: context.text.labelSmall,
                                  ),
                                ],
                              ),
                              Text(
                                online
                                    ? l10n.driverOnlineHint
                                    : l10n.driverOfflineHint,
                                style: context.text.titleMedium,
                              ),
                            ],
                          ),
                        ),
                        controller.isToggling.value
                            ? const CircularProgressIndicator()
                            : FilledButton(
                                style: FilledButton.styleFrom(
                                  minimumSize: Size.zero,
                                  backgroundColor:
                                      online ? colors.danger : colors.brand,
                                ),
                                onPressed: () => controller.setOnline(!online),
                                child: Text(
                                  online
                                      ? l10n.driverGoOffline
                                      : l10n.driverGoOnline,
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const LocationStatusCard(),
                  if (failure != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    ErrorBanner(failure: failure),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
            SectionHeader(title: l10n.driverCurrentTask),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: current == null
                  ? Text(l10n.driverNoTask, style: context.text.bodySmall)
                  : DriverOrderCard(
                      order: current,
                      onTap: () async {
                        await Get.toNamed<void>(
                          AppRoutes.driverOrder,
                          arguments: current.id,
                        );
                        await controller.refreshAll();
                      },
                    ),
            ),
            SectionHeader(title: l10n.driverTodaySummary),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: StatTile(
                      icon: LucideIcons.fileText,
                      value: '${today?.orders ?? 0}',
                      label: l10n.driverTodayOrders,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: StatTile(
                      icon: LucideIcons.wallet,
                      value: today?.earnings.formatted ?? '—',
                      label: l10n.driverTodayEarnings,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
