import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'state_tone.dart';

/// Small pill showing a machine code (error code, status key).
class CodeChip extends StatelessWidget {
  const CodeChip({
    super.key,
    required this.label,
    this.tone = StateTone.danger,
  });

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
      child: Text(
        label,
        textDirection: TextDirection.ltr,
        style:
            context.text.labelSmall?.copyWith(color: tone.foreground(colors)),
      ),
    );
  }
}
