import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Onboarding pager indicator; the active dot stretches.
class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var index = 0; index < count; index++)
          AnimatedContainer(
            duration: AppDurations.dot,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            width: index == current ? AppSizes.pageDotActive : AppSizes.pageDot,
            height: AppSizes.pageDot,
            decoration: BoxDecoration(
              color: index == current ? colors.brand : colors.disabled,
              borderRadius: AppRadius.pillAll,
            ),
          ),
      ],
    );
  }
}
