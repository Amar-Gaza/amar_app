import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/dot_pill.dart';
import 'driver_card.dart';
import 'earnings_bar.dart';

/// Total earnings of the selected period with a bar per series entry.
class EarningsChartCard extends StatelessWidget {
  const EarningsChartCard({super.key, required this.earnings});

  /// Up to this many bars show their value and a weekday label.
  static const int _detailedBars = 7;

  final Earnings earnings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final locale = Localizations.localeOf(context).languageCode;
    final series = earnings.series;
    final max = series.fold<int>(
      0,
      (m, e) => e.earnings.amount > m ? e.earnings.amount : m,
    );
    final detailed = series.length <= _detailedBars;
    return DriverCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.driverTotalEarnings,
                      style: context.text.labelMedium
                          ?.copyWith(color: colors.mutedText),
                    ),
                    Text(
                      earnings.earnings.formatted,
                      style: context.text.headlineLarge
                          ?.copyWith(color: colors.brand),
                    ),
                  ],
                ),
              ),
              // TODO(design): the design shows a growth percentage; the API
              // has no previous-period figure, so the order count is shown.
              DotPill(label: l10n.driverOrdersCount('${earnings.orders}')),
            ],
          ),
          if (series.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: AppSizes.chartHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final entry in series) ...[
                    Expanded(
                      child: EarningsBar(
                        ratio: max > 0 ? entry.earnings.amount / max : 0,
                        highlighted: max > 0 && entry.earnings.amount == max,
                        value: detailed ? entry.earnings.formatted : null,
                        label: switch (DateTime.tryParse(entry.date)) {
                          final DateTime date when detailed =>
                            DateFormatter.weekday(date, locale),
                          final DateTime date =>
                            DateFormatter.day(date, locale),
                          null => entry.date,
                        },
                      ),
                    ),
                    if (entry != series.last)
                      SizedBox(
                        width: detailed ? AppSpacing.sm : AppSpacing.xs / 2,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
