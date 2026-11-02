import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/hero_card.dart';
import 'progress_segments.dart';

/// Gradient card on home for the customer's most recent active order.
class ActiveOrderCard extends StatelessWidget {
  const ActiveOrderCard({
    super.key,
    required this.order,
    required this.totalSteps,
    required this.currentStep,
    required this.onTap,
  });

  final OrderSummary order;
  final int totalSteps;
  final int currentStep;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final caption = context.text.bodySmall?.copyWith(color: colors.accent);
    return HeroCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.orderCode(order.code), style: caption),
          Text(
            order.status.label,
            style: context.text.titleLarge?.copyWith(color: colors.onBrand),
          ),
          if (totalSteps > 0) ...[
            const SizedBox(height: AppSpacing.md),
            ProgressSegments(total: totalSteps, current: currentStep),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.homeOrderHint, style: caption),
        ],
      ),
    );
  }
}
