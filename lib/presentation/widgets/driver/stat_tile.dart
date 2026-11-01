import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Icon, value and label in a bordered box (summary tiles).
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.scheme.surface,
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: context.appColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: AppSizes.iconMd, color: context.appColors.brand),
            const SizedBox(height: AppSpacing.sm),
            Text(value, style: context.text.titleLarge),
            Text(
              label,
              style: context.text.labelSmall
                  ?.copyWith(color: context.appColors.mutedText),
            ),
          ],
        ),
      );
}
