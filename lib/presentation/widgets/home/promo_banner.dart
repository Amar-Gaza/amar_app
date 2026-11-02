import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';

/// Fixed promo from the design. No endpoint backs it yet.
class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key, required this.onAction});

  static const double _iconSize = 70;

  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: colors.promoGradient,
        borderRadius: AppRadius.cardAll,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.promoTitle,
                  style: context.text.headlineSmall
                      ?.copyWith(color: colors.onPromo),
                ),
                Text(
                  l10n.promoSubtitle,
                  style:
                      context.text.bodySmall?.copyWith(color: colors.onPromo),
                ),
                const SizedBox(height: AppSpacing.sm),
                GestureDetector(
                  onTap: onAction,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: colors.onPromo,
                      borderRadius: AppRadius.segmentInnerAll,
                    ),
                    child: Text(
                      l10n.promoAction,
                      style: context.text.labelMedium
                          ?.copyWith(color: colors.onBrand),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(LucideIcons.wrench, size: _iconSize, color: colors.onPromo),
        ],
      ),
    );
  }
}
