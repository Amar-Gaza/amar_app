import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../common/blinking_dot.dart';

/// Segmented progress of a job: done segments green, the current one
/// blinking amber.
class StageBar extends StatelessWidget {
  const StageBar({super.key, required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: ClipRRect(
              borderRadius: AppRadius.pillAll,
              child: SizedBox(
                height: AppSizes.progressHeight,
                child: i == current
                    ? BlinkingDot(
                        color: colors.amber,
                        size: double.infinity,
                        shape: BoxShape.rectangle,
                      )
                    : ColoredBox(
                        color: i < current ? colors.brandBright : colors.border,
                      ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
