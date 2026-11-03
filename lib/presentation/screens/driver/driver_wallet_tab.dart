import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/driver/driver_wallet_controller.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/segment_item.dart';
import '../../widgets/common/segmented_tabs.dart';
import '../../widgets/common/skeleton_list.dart';
import '../../widgets/driver/cash_hero_card.dart';
import '../../widgets/driver/count_section_title.dart';
import '../../widgets/driver/earnings_chart_card.dart';
import '../../widgets/driver/settlement_tile.dart';

/// Balance: cash on hand vs. limit, earnings per period and settlements.
class DriverWalletTab extends GetView<DriverWalletController> {
  const DriverWalletTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Obx(() {
      final cash = controller.cash.value;
      final earnings = controller.earnings.value;
      final failure = controller.failure.value;
      if (controller.isLoading.value && cash == null) {
        return const SafeArea(child: SkeletonList(showSearch: false, rows: 3));
      }
      if (cash == null || earnings == null) {
        return failure != null
            ? ErrorView(failure: failure, onRetry: controller.load)
            : const SizedBox.shrink();
      }
      return RefreshIndicator(
        onRefresh: controller.load,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.page,
            MediaQuery.paddingOf(context).top + AppSpacing.sm,
            AppSpacing.page,
            AppSizes.navBubble,
          ),
          children: [
            Text(l10n.driverNavWallet, style: context.text.headlineLarge),
            const SizedBox(height: AppSpacing.md),
            if (failure != null) ...[
              ErrorBanner(failure: failure),
              const SizedBox(height: AppSpacing.md),
            ],
            CashHeroCard(cash: cash),
            const SizedBox(height: AppSpacing.lg),
            SegmentedTabs<String>(
              selected: controller.period.value,
              onSelect: controller.selectPeriod,
              items: [
                SegmentItem(
                  value: EarningsPeriod.day,
                  label: l10n.driverPeriodDay,
                ),
                SegmentItem(
                  value: EarningsPeriod.week,
                  label: l10n.driverPeriodWeek,
                ),
                SegmentItem(
                  value: EarningsPeriod.month,
                  label: l10n.driverPeriodMonth,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            EarningsChartCard(earnings: earnings),
            CountSectionTitle(title: l10n.driverTransactions),
            if (cash.settlements.isEmpty)
              Text(l10n.driverNoSettlements, style: context.text.bodySmall)
            else
              for (final settlement in cash.settlements)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: SettlementTile(settlement: settlement),
                ),
          ],
        ),
      );
    });
  }
}
