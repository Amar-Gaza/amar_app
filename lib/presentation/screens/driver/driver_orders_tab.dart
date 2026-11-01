import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/driver/driver_orders_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/empty_view.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/skeleton_list.dart';
import '../../widgets/driver/driver_order_card.dart';
import '../../widgets/orders/order_card.dart';
import '../../widgets/orders/scope_tabs.dart';

/// Available jobs and history (designs 08, 09).
class DriverOrdersTab extends GetView<DriverOrdersController> {
  const DriverOrdersTab({super.key});

  Future<void> _open(int id) async {
    await Get.toNamed<void>(AppRoutes.driverOrder, arguments: id);
    await controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        AppTopBar(title: l10n.driverNavOrders, showBack: false),
        Obx(
          () => ScopeTabs(
            selected: controller.view.value.name,
            onSelect: (v) =>
                controller.select(DriverOrdersView.values.byName(v)),
            labels: {
              DriverOrdersView.available.name: l10n.driverAvailable,
              DriverOrdersView.history.name: l10n.driverHistory,
            },
          ),
        ),
        Expanded(
          child: Obx(() {
            final failure = controller.failure.value;
            final available =
                controller.view.value == DriverOrdersView.available;
            final count = available
                ? controller.available.length
                : controller.history.length;
            if (controller.isLoading.value && count == 0) {
              return const SkeletonList(showSearch: false);
            }
            if (failure != null && count == 0) {
              return ErrorView(failure: failure, onRetry: controller.load);
            }
            if (count == 0) {
              return EmptyView(
                icon: LucideIcons.inbox,
                title:
                    available ? l10n.driverNoAvailable : l10n.driverNoHistory,
                actionLabel: l10n.commonRefresh,
                onAction: controller.load,
              );
            }
            return RefreshIndicator(
              onRefresh: controller.load,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                itemCount: count,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (_, i) => available
                    ? DriverOrderCard(
                        order: controller.available[i],
                        onTap: () => _open(controller.available[i].id),
                      )
                    : OrderCard(
                        order: controller.history[i],
                        onTap: () => _open(controller.history[i].id),
                      ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
