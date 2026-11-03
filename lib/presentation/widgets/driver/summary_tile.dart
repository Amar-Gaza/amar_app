import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Small stat box in the driver orders summary; [highlighted] uses the
/// green hero gradient.
class SummaryTile extends StatelessWidget {
  const SummaryTile({
    super.key,
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final foreground = highlighted ? colors.onBrand : colors.ink;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        gradient: highlighted ? colors.heroGradient : null,
        color: highlighted ? null : colors.surfaceSoft,
        borderRadius: AppRadius.cardAll,
      ),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.labelSmall?.copyWith(
              color: highlighted ? colors.accent : colors.mutedText,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: context.text.headlineMedium?.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}
