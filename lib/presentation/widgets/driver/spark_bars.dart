import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Tiny bar chart on the earnings hero; the highest bar is amber.
class SparkBars extends StatelessWidget {
  const SparkBars({super.key, required this.values});

  static const double _barAlpha = 0.35;
  static const double _minRatio = 0.08;

  final List<num> values;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final max = values.fold<num>(0, (a, b) => b > a ? b : a);
    final peak = max > 0 ? values.indexOf(max) : -1;
    return SizedBox(
      height: AppSizes.sparkHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < values.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.xs),
            Container(
              width: AppSizes.sparkBarWidth,
              height: AppSizes.sparkHeight *
                  (max > 0 ? (values[i] / max).clamp(_minRatio, 1) : _minRatio),
              decoration: BoxDecoration(
                color: i == peak
                    ? colors.amber
                    : colors.onBrand.withValues(alpha: _barAlpha),
                borderRadius: AppRadius.smAll,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
