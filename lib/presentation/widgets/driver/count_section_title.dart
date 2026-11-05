import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Section title on the driver home with an optional count badge.
class CountSectionTitle extends StatelessWidget {
  const CountSectionTitle({super.key, required this.title, this.count});

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.page,
        bottom: AppSpacing.md,
      ),
      child: Row(
        children: [
          Text(title, style: context.text.headlineSmall),
          if (count != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              decoration: BoxDecoration(
                color: colors.brandBright,
                borderRadius: AppRadius.smAll,
              ),
              child: Text(
                '$count',
                style:
                    context.text.labelMedium?.copyWith(color: colors.onBrand),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
