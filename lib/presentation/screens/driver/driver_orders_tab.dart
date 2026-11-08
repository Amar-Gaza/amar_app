import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/driver/driver_home_controller.dart';
import '../../../controllers/driver/driver_orders_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/common/count_chip.dart';
import '../../widgets/common/empty_view.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/group_label.dart';
import '../../widgets/common/skeleton_list.dart';
import '../../widgets/driver/history_order_tile.dart';
import '../../widgets/driver/summary_tile.dart';

enum _HistoryFilter { all, completed, cancelled }

/// "My orders": today's summary, status filters and history grouped by day.
/// Available offers live on the home tab.
class DriverOrdersTab extends StatefulWidget {
  const DriverOrdersTab({super.key});

  @override
  State<DriverOrdersTab> createState() => _DriverOrdersTabState();
}

class _DriverOrdersTabState extends State<DriverOrdersTab> {
  final DriverOrdersController _orders = Get.find<DriverOrdersController>();
  final DriverHomeController _home = Get.find<DriverHomeController>();
  late final Worker _tabWorker;
  _HistoryFilter _filter = _HistoryFilter.all;

  @override
  void initState() {
    super.initState();
    _orders.loadHistory();
    _tabWorker = ever<DriverTab>(_home.tab, (tab) {
      if (tab == DriverTab.orders) _orders.loadHistory();
    });
  }

  @override
  void dispose() {
    _tabWorker.dispose();
    super.dispose();
  }

  static bool _isCancelled(OrderSummary o) =>
      o.status.key == StatusKeys.cancelled;

  static bool _isCompleted(OrderSummary o) =>
      o.status.key == StatusKeys.delivered ||
      o.status.key == StatusKeys.serviceCompleted;

  Future<void> _open(int id) async {
    await Get.toNamed<void>(AppRoutes.driverOrder, arguments: id);
    await _orders.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return Obx(() {
      final history = _orders.history;
      final failure = _orders.failure.value;
      if (_orders.isLoading.value && history.isEmpty) {
        return const SafeArea(child: SkeletonList(showSearch: false));
      }
      if (failure != null && history.isEmpty) {
        return ErrorView(failure: failure, onRetry: _orders.loadHistory);
      }
      if (history.isEmpty) {
        return EmptyView(
          icon: LucideIcons.inbox,
          title: l10n.driverNoHistory,
          actionLabel: l10n.commonRefresh,
          onAction: _orders.loadHistory,
        );
      }
      final completed = history.where(_isCompleted).length;
      final cancelled = history.where(_isCancelled).length;
      final visible = history.where(
        (o) => switch (_filter) {
          _HistoryFilter.all => true,
          _HistoryFilter.completed => _isCompleted(o),
          _HistoryFilter.cancelled => _isCancelled(o),
        },
      );
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final groups = <DateTime, List<OrderSummary>>{};
      for (final order in visible) {
        final at = (order.completedAt ?? order.createdAt).toLocal();
        groups
            .putIfAbsent(DateTime(at.year, at.month, at.day), () => [])
            .add(order);
      }
      final filters = [
        (_HistoryFilter.all, l10n.driverFilterAll, history.length),
        (_HistoryFilter.completed, l10n.driverFilterCompleted, completed),
        (_HistoryFilter.cancelled, l10n.driverFilterCancelled, cancelled),
      ];
      return RefreshIndicator(
        onRefresh: _orders.loadHistory,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.page,
            MediaQuery.paddingOf(context).top + AppSpacing.sm,
            AppSpacing.page,
            MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
          ),
          children: [
            Text(l10n.driverNavOrders, style: context.text.headlineLarge),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: SummaryTile(
                    label: l10n.driverTodayEarnings,
                    value: _home.today.value?.earnings.formatted ?? '—',
                    highlighted: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryTile(
                    label: l10n.driverCompleted,
                    value: '$completed',
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryTile(
                    label: l10n.driverCancelled,
                    value: '$cancelled',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final (filter, label, count) in filters)
                  CountChip(
                    label: label,
                    count: count,
                    selected: _filter == filter,
                    onTap: () => setState(() => _filter = filter),
                  ),
              ],
            ),
            for (final entry in groups.entries) ...[
              GroupLabel(
                label: entry.key == today
                    ? l10n.driverPeriodDay
                    : today.difference(entry.key).inDays == 1
                        ? l10n.driverYesterday
                        : DateFormatter.dayMonth(entry.key, locale),
              ),
              for (final order in entry.value)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: HistoryOrderTile(
                    order: order,
                    cancelled: _isCancelled(order),
                    onTap: () => _open(order.id),
                  ),
                ),
            ],
          ],
        ),
      );
    });
  }
}
