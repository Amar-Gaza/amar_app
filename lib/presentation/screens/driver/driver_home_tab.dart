import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/driver/driver_home_controller.dart';
import '../../../controllers/driver/driver_orders_controller.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/skeleton_box.dart';
import '../../widgets/driver/available_order_card.dart';
import '../../widgets/driver/count_section_title.dart';
import '../../widgets/driver/current_task_card.dart';
import '../../widgets/driver/driver_home_header.dart';
import '../../widgets/driver/driver_offline_card.dart';
import '../../widgets/driver/earnings_hero_card.dart';
import '../../widgets/driver/location_chip.dart';
import '../../widgets/driver/no_available_orders.dart';

/// Dashboard: header with the online switch, location, today's earnings,
/// then the current task, the available offers or the offline card.
class DriverHomeTab extends GetView<DriverHomeController> {
  const DriverHomeTab({super.key});

  static const double _heroSkeleton = 200;

  /// [offer] is passed for an available order, whose details the server
  /// returns only after it is accepted.
  Future<void> _open(int id, {DriverOrder? offer}) async {
    await Get.toNamed<void>(AppRoutes.driverOrder, arguments: offer ?? id);
    await controller.refreshAll();
  }

  Future<void> _toggle(BuildContext context, bool online) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await controller.setOnline(online);
    if (controller.isOnline != online) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(online ? l10n.driverNowOnline : l10n.driverNowOffline),
        ),
      );
  }

  Future<void> _refresh() => Future.wait([
        controller.refreshAll(),
        Get.find<DriverOrdersController>().load(),
      ]);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final orders = Get.find<DriverOrdersController>();
    return Obx(() {
      final driver = controller.driver;
      final online = controller.isOnline;
      final current = controller.current.value;
      final today = controller.today.value;
      final failure = controller.failure.value;
      final firstLoad = controller.isLoading.value && today == null;
      final available = orders.available;
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.page,
            MediaQuery.paddingOf(context).top + AppSpacing.sm,
            AppSpacing.page,
            AppSpacing.xxl,
          ),
          children: [
            DriverHomeHeader(
              driver: driver,
              online: online,
              toggling: controller.isToggling.value,
              onToggle: () => _toggle(context, !online),
              onNotifications: () =>
                  Get.toNamed<void>(AppRoutes.driverNotifications),
            ),
            const SizedBox(height: AppSpacing.md),
            const LocationChip(),
            const SizedBox(height: AppSpacing.md),
            if (failure != null) ...[
              ErrorBanner(failure: failure),
              const SizedBox(height: AppSpacing.md),
            ],
            if (firstLoad)
              const SkeletonBox(
                height: _heroSkeleton,
                borderRadius: AppRadius.heroAll,
              )
            else
              EarningsHeroCard(today: today, rating: driver?.rating),
            if (current != null) ...[
              CountSectionTitle(title: l10n.driverYourTask),
              CurrentTaskCard(
                order: current,
                onOpen: () => _open(current.id),
              ),
            ] else if (online) ...[
              CountSectionTitle(
                title: l10n.driverAvailableOrders,
                count: available.length,
              ),
              if (orders.failure.value != null)
                ErrorBanner(failure: orders.failure.value!)
              else if (orders.isLoading.value && available.isEmpty)
                const SkeletonBox(
                  height: _heroSkeleton,
                  borderRadius: AppRadius.sheetAll,
                )
              else if (available.isEmpty)
                const NoAvailableOrders()
              else
                for (final order in available)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AvailableOrderCard(
                      order: order,
                      onAccept: () => _open(order.id, offer: order),
                    ),
                  ),
            ] else ...[
              const SizedBox(height: AppSpacing.page),
              const DriverOfflineCard(),
            ],
            SizedBox(height: MediaQuery.paddingOf(context).bottom),
          ],
        ),
      );
    });
  }
}
