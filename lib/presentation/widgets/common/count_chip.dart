import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Outlined filter pill with a count bubble; filled brand when selected.
class CountChip extends StatelessWidget {
  const CountChip({
    super.key,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  static const double _bubbleAlpha = 0.1;

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final foreground = selected ? colors.onBrand : colors.ink;
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.pillAll,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected ? colors.brand : context.scheme.surface,
            borderRadius: AppRadius.pillAll,
            border: Border.all(
              color: selected ? colors.brand : colors.border,
              width: AppSizes.borderWidthField,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: context.text.labelMedium?.copyWith(color: foreground),
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                constraints: const BoxConstraints(
                  minWidth: AppSizes.navBadge,
                  minHeight: AppSizes.navBadge,
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.ink.withValues(alpha: _bubbleAlpha),
                  borderRadius: AppRadius.pillAll,
                ),
                child: Text(
                  '$count',
                  style: context.text.labelSmall?.copyWith(color: foreground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
