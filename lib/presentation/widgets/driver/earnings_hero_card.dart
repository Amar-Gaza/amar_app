import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/hero_circle.dart';
import 'hero_stat.dart';
import 'spark_bars.dart';

/// Green hero on the driver home: today's earnings, a spark chart and the
/// orders / hours / rating strip.
class EarningsHeroCard extends StatelessWidget {
  const EarningsHeroCard({super.key, this.today, this.rating});

  static const double _bigCircleAlpha = 0.08;
  static const double _smallCircleAlpha = 0.06;
  static const double _stripAlpha = 0.12;
  static const String _empty = '—';

  final Earnings? today;
  final Rating? rating;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final series = today?.series ?? const <EarningsSeries>[];
    final ratingValue = rating;
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: colors.heroGradient,
        borderRadius: AppRadius.heroAll,
        boxShadow: AppShadows.hero(colors),
      ),
      child: Stack(
        children: [
          const PositionedDirectional(
            top: -AppSizes.heroCircleLg / 3,
            start: -AppSizes.heroCircleLg / 4,
            child: HeroCircle(
              size: AppSizes.heroCircleLg,
              alpha: _bigCircleAlpha,
            ),
          ),
          const PositionedDirectional(
            bottom: -AppSizes.heroCircleSm / 2,
            end: AppSizes.heroCircleSm / 2,
            child: HeroCircle(
              size: AppSizes.heroCircleSm,
              alpha: _smallCircleAlpha,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.page),
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
                            l10n.driverTodayEarnings,
                            style: context.text.labelMedium
                                ?.copyWith(color: colors.accent),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              today?.earnings.formatted ?? _empty,
                              style: context.text.headlineLarge?.copyWith(
                                color: colors.onBrand,
                                fontSize: AppTypography.splash,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (series.isNotEmpty)
                      SparkBars(
                        values: [for (final s in series) s.earnings.amount],
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colors.onBrand.withValues(alpha: _stripAlpha),
                    borderRadius: AppRadius.cardAll,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: HeroStat(
                          icon: LucideIcons.shoppingBag,
                          value: today == null ? _empty : '${today!.orders}',
                          label: l10n.driverHeroOrders,
                        ),
                      ),
                      // TODO(design): the API has no online-hours figure yet.
                      Expanded(
                        child: HeroStat(
                          icon: LucideIcons.clock,
                          value: _empty,
                          label: l10n.driverHeroHours,
                        ),
                      ),
                      Expanded(
                        child: HeroStat(
                          icon: LucideIcons.star,
                          value: ratingValue == null || ratingValue.count == 0
                              ? _empty
                              : ratingValue.average.toStringAsFixed(1),
                          label: l10n.driverHeroRating,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
