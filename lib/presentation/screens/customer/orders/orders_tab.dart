import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../controllers/customer/orders_controller.dart';
import '../../../../controllers/customer/shell_controller.dart';
import '../../../../core/constants/api_query.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_top_bar.dart';
import '../../../widgets/common/empty_view.dart';
import '../../../widgets/common/error_view.dart';
import '../../../widgets/common/skeleton_list.dart';
import '../../../widgets/orders/order_card.dart';
import '../../../widgets/orders/scope_tabs.dart';

/// Orders tab: GET /v1/orders by scope.
class OrdersTab extends GetView<OrdersController> {
  const OrdersTab({super.key});

  static const double _loadMoreExtent = 200;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shell = Get.find<ShellController>();
    return Column(
      children: [
        AppTopBar(title: l10n.navOrders, showBack: false),
        Obx(
          () => ScopeTabs(
            selected: controller.scope.value,
            onSelect: controller.selectScope,
            labels: {
              OrderScope.active: l10n.ordersScopeActive,
              OrderScope.completed: l10n.ordersScopeCompleted,
              OrderScope.cancelled: l10n.ordersScopeCancelled,
            },
          ),
        ),
        Expanded(
          child: Obx(() {
            final failure = controller.failure.value;
            if (controller.isLoading.value && controller.items.isEmpty) {
              return const SkeletonList(showSearch: false);
            }
            if (failure != null && controller.items.isEmpty) {
              return ErrorView(failure: failure, onRetry: controller.load);
            }
            if (controller.items.isEmpty) {
              return EmptyView(
                icon: LucideIcons.package,
                title: l10n.ordersEmptyTitle,
                message: l10n.ordersEmptyMessage,
                actionLabel: l10n.ordersExplore,
                onAction: () => shell.select(CustomerTab.home),
                secondaryLabel: l10n.commonRefresh,
                onSecondary: controller.load,
              );
            }
            return RefreshIndicator(
              onRefresh: controller.load,
              child: NotificationListener<ScrollNotification>(
                onNotification: (scroll) {
                  if (scroll.metrics.extentAfter < _loadMoreExtent) {
                    controller.loadMore();
                  }
                  return false;
                },
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  itemCount: controller.items.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (_, index) => index == controller.items.length
                      ? const Center(child: CircularProgressIndicator())
                      : OrderCard(
                          order: controller.items[index],
                          onTap: () async {
                            await Get.toNamed<void>(
                              AppRoutes.order,
                              arguments: controller.items[index].id,
                            );
                            await controller.load();
                          },
                        ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
