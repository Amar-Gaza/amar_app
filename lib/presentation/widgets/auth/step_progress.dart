import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Step caption with a percentage and a thin progress bar.
class StepProgress extends StatelessWidget {
  const StepProgress({super.key, required this.label, required this.value});

  static const int _percent = 100;

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final muted =
        context.text.labelSmall?.copyWith(color: context.appColors.mutedText);
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: muted)),
            Text('${(value * _percent).round()}%', style: muted),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: AppRadius.pillAll,
          child: LinearProgressIndicator(
            value: value,
            minHeight: AppSizes.progressHeight,
          ),
        ),
      ],
    );
  }
}
