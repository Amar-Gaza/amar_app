import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/hero_circle.dart';

/// Green wallet hero: cash on hand, progress toward the cash limit and
/// settlement hints.
class CashHeroCard extends StatelessWidget {
  const CashHeroCard({super.key, required this.cash});

  static const double _bigCircleAlpha = 0.08;
  static const double _smallCircleAlpha = 0.06;
  static const double _boxAlpha = 0.14;
  static const double _trackAlpha = 0.2;
  static const int _percent = 100;

  final Cash cash;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final limit = cash.maxCash.amount;
    final ratio =
        limit <= 0 ? 0.0 : (cash.cashOnHand.amount / limit).clamp(0.0, 1.0);
    final hasCash = cash.cashOnHand.amount > 0;
    final caption = context.text.labelSmall?.copyWith(color: colors.accent);
    final value = context.text.titleMedium?.copyWith(color: colors.onBrand);
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
            top: -AppSizes.heroCircleLg / 2.4,
            end: -AppSizes.heroCircleLg / 4,
            child: HeroCircle(
              size: AppSizes.heroCircleLg,
              alpha: _bigCircleAlpha,
            ),
          ),
          const PositionedDirectional(
            bottom: -AppSizes.heroCircleSm / 3,
            start: -AppSizes.heroCircleSm / 6,
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
                // TODO(design): the design's top line is an "earnings
                // balance"; the API has no balance, so the hero leads with
                // cash on hand.
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.driverCashTitle,
                            style: context.text.labelMedium
                                ?.copyWith(color: colors.accent),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              cash.cashOnHand.formatted,
                              style: context.text.headlineLarge?.copyWith(
                                color: colors.onBrand,
                                fontSize: AppTypography.splash,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: hasCash ? colors.amber : colors.accent,
                        borderRadius: AppRadius.mdAll,
                      ),
                      child: Text(
                        hasCash ? l10n.driverCashDue : l10n.driverNoCash,
                        style: context.text.labelSmall?.copyWith(
                          color: hasCash ? colors.onAmber : colors.brandDeep,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colors.onBrand.withValues(alpha: _boxAlpha),
                    borderRadius: AppRadius.cardAll,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: AppRadius.pillAll,
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: AppSizes.cashBarHeight,
                          color: ratio >= 1 ? colors.danger : colors.amber,
                          backgroundColor:
                              colors.onBrand.withValues(alpha: _trackAlpha),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.driverCashLimitValue(cash.maxCash.formatted),
                              style: caption,
                            ),
                          ),
                          Text(
                            '${(ratio * _percent).round()}%',
                            style: caption,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (cash.remaining != null)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.driverCashRemaining,
                                style: caption,
                              ),
                            ),
                            Text(cash.remaining!.formatted, style: value),
                          ],
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(l10n.driverUnsettled, style: caption),
                          ),
                          Text('${cash.unsettledOrders}', style: value),
                        ],
                      ),
                    ],
                  ),
                ),
                // TODO(design): the design has a "Settle cash" button; the
                // driver API has no settle endpoint (admin settles), so a
                // hint is shown instead.
                if (hasCash) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    ratio >= 1
                        ? l10n.driverCashLimitReached
                        : l10n.driverHandCash,
                    textAlign: TextAlign.center,
                    style: context.text.labelMedium
                        ?.copyWith(color: colors.onBrand),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
