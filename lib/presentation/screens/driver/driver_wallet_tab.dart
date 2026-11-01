import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/driver/driver_wallet_controller.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/label_value_row.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/info_banner.dart';
import '../../widgets/common/skeleton_list.dart';
import '../../widgets/common/state_tone.dart';
import '../../widgets/driver/stat_tile.dart';
import '../../widgets/orders/scope_tabs.dart';
import '../../widgets/orders/section_card.dart';

/// Cash, settlements and earnings (designs 26–30).
class DriverWalletTab extends GetView<DriverWalletController> {
  const DriverWalletTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final locale = Localizations.localeOf(context).languageCode;
    return Column(
      children: [
        AppTopBar(title: l10n.driverNavWallet, showBack: false),
        Expanded(
          child: Obx(() {
            final cash = controller.cash.value;
            final earnings = controller.earnings.value;
            final failure = controller.failure.value;
            if (controller.isLoading.value && cash == null) {
              return const SkeletonList(showSearch: false, rows: 3);
            }
            if (cash == null || earnings == null) {
              return failure != null
                  ? ErrorView(failure: failure, onRetry: controller.load)
                  : const SizedBox.shrink();
            }
            final limit = cash.maxCash.amount;
            final ratio = limit <= 0
                ? 0.0
                : (cash.cashOnHand.amount / limit).clamp(0.0, 1.0);
            final maxSeries = earnings.series.fold<int>(
              1,
              (m, e) => e.earnings.amount > m ? e.earnings.amount : m,
            );
            return RefreshIndicator(
              onRefresh: controller.load,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  SectionCard(
                    title: l10n.driverCashTitle,
                    children: [
                      Text(
                        cash.cashOnHand.formatted,
                        style: context.text.headlineLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ClipRRect(
                        borderRadius: AppRadius.pillAll,
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: AppSizes.progressHeight,
                          color: ratio >= 1 ? colors.danger : colors.brand,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      LabelValueRow(
                        label: l10n.driverCashLimit,
                        value: cash.maxCash.formatted,
                      ),
                      if (cash.remaining != null)
                        LabelValueRow(
                          label: l10n.driverCashRemaining,
                          value: cash.remaining!.formatted,
                        ),
                      LabelValueRow(
                        label: l10n.driverUnsettled,
                        value: '${cash.unsettledOrders}',
                      ),
                      if (ratio >= 1)
                        InfoBanner(
                          title: l10n.driverCashLimitReached,
                          tone: StateTone.danger,
                        ),
                    ],
                  ),
                  SectionCard(
                    title: l10n.driverSettlements,
                    children: [
                      if (cash.settlements.isEmpty)
                        Text(l10n.driverNoSettlements,
                            style: context.text.bodySmall),
                      for (final settlement in cash.settlements)
                        LabelValueRow(
                          icon: LucideIcons.handCoins,
                          label:
                              DateFormatter.dayMonthTime(settlement.at, locale),
                          value: settlement.amount.formatted,
                        ),
                    ],
                  ),
                  ScopeTabs(
                    selected: controller.period.value,
                    onSelect: controller.selectPeriod,
                    labels: {
                      EarningsPeriod.day: l10n.driverPeriodDay,
                      EarningsPeriod.week: l10n.driverPeriodWeek,
                      EarningsPeriod.month: l10n.driverPeriodMonth,
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          icon: LucideIcons.wallet,
                          value: earnings.earnings.formatted,
                          label: l10n.driverEarnings,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: StatTile(
                          icon: LucideIcons.fileText,
                          value: '${earnings.orders}',
                          label: l10n.driverTodayOrders,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SectionCard(
                    title: l10n.driverEarningsHistory,
                    children: [
                      for (final day in earnings.series)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Row(
                            children: [
                              SizedBox(
                                width: AppSizes.productImage,
                                child: Text(day.date,
                                    style: context.text.labelSmall),
                              ),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: AppRadius.pillAll,
                                  child: LinearProgressIndicator(
                                    value: day.earnings.amount / maxSeries,
                                    minHeight: AppSizes.progressHeight * 2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(day.earnings.formatted,
                                  style: context.text.labelSmall),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
