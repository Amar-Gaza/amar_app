import 'package:flutter/material.dart';

import '../../../core/constants/app_defaults.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Row of bars showing the current step of the sign-up flow.
class FormSteps extends StatelessWidget {
  const FormSteps({super.key, required this.current});

  /// One-based number of the active step.
  final int current;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      children: [
        for (var step = 1; step <= AppDefaults.authSteps; step++) ...[
          if (step > 1) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Container(
              height: AppSizes.stepHeight,
              decoration: BoxDecoration(
                color: step <= current ? colors.brandBright : colors.border,
                borderRadius: AppRadius.pillAll,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
