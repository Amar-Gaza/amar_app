import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// One column of the earnings chart: value on top, bar, label below.
class EarningsBar extends StatelessWidget {
  const EarningsBar({
    super.key,
    required this.ratio,
    required this.label,
    required this.highlighted,
    this.value,
  });

  static const double _minRatio = 0.04;

  final double ratio;
  final String label;
  final bool highlighted;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final small = context.text.labelSmall;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (value != null)
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value!,
              style: small?.copyWith(
                color: highlighted ? colors.brand : colors.subtleText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.xs),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: ratio.clamp(_minRatio, 1),
              child: AnimatedContainer(
                duration: AppDurations.dot,
                decoration: BoxDecoration(
                  color: highlighted ? null : colors.brandSoft,
                  gradient: highlighted
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [colors.brandBright, colors.brand],
                        )
                      : null,
                  borderRadius: AppRadius.smAll,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: small?.copyWith(color: colors.mutedText),
          ),
        ),
      ],
    );
  }
}
