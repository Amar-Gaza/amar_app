import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';

/// Segmented progress from the status step (designs 05, 13).
class StatusProgress extends StatelessWidget {
  const StatusProgress({super.key, required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final count = total < 1 ? 1 : total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            for (var i = 1; i <= count; i++)
              Expanded(
                child: Container(
                  height: AppSizes.progressHeight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xs / 2),
                  decoration: BoxDecoration(
                    color: i <= step ? colors.brand : colors.skeleton,
                    borderRadius: AppRadius.pillAll,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppLocalizations.of(context).orderStepOf(step.clamp(0, count), count),
          style: context.text.labelSmall?.copyWith(color: colors.mutedText),
        ),
      ],
    );
  }
}
