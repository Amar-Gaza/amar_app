import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'blinking_dot.dart';
import 'state_tone.dart';

/// Tinted chip with an optional blinking dot ("New", "In progress").
class DotPill extends StatelessWidget {
  const DotPill({
    super.key,
    required this.label,
    this.tone = StateTone.success,
    this.dotColor,
  });

  /// Shows a blinking dot of this color before the label.
  final Color? dotColor;
  final String label;
  final StateTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tone.background(colors),
        borderRadius: AppRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dotColor != null) ...[
            BlinkingDot(color: dotColor!),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            maxLines: 1,
            style: context.text.labelMedium?.copyWith(
              color: tone.foreground(colors),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
