import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Order progress on a gradient card: done, current and upcoming steps.
class ProgressSegments extends StatelessWidget {
  const ProgressSegments({
    super.key,
    required this.total,
    required this.current,
  });

  static const double _upcomingAlpha = 0.2;

  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      children: [
        for (var step = 0; step < total; step++) ...[
          if (step > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Container(
              height: AppSizes.progressHeight,
              decoration: BoxDecoration(
                color: step < current
                    ? colors.onBrand
                    : step == current
                        ? colors.amber
                        : colors.onBrand.withValues(alpha: _upcomingAlpha),
                borderRadius: AppRadius.pillAll,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
