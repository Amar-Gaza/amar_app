import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'state_tone.dart';

/// Large, slightly tilted tile used at the top of full-screen states.
class StatusIllustration extends StatelessWidget {
  const StatusIllustration({
    super.key,
    required this.icon,
    this.tone = StateTone.brand,
    this.caption,
    this.showDot = false,
  });

  final IconData icon;
  final StateTone tone;
  final String? caption;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final foreground = tone.foreground(colors);
    return Transform.rotate(
      angle: AppSizes.illustrationTilt,
      child: Container(
        width: AppSizes.statusIllustration,
        height: AppSizes.statusIllustration,
        decoration: BoxDecoration(
          color: tone.background(colors),
          borderRadius: AppRadius.xlAll,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: AppSizes.iconLg, color: foreground),
                if (caption != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    caption!,
                    style: context.text.labelSmall?.copyWith(color: foreground),
                  ),
                ],
              ],
            ),
            if (showDot)
              PositionedDirectional(
                top: AppSpacing.lg,
                end: AppSpacing.lg,
                child: Container(
                  width: AppSizes.offlineDot,
                  height: AppSizes.offlineDot,
                  decoration: BoxDecoration(
                    color: colors.danger,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
