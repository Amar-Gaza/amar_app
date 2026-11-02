import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'state_tone.dart';

/// Small tinted label: vendor tags and state chips.
class TonePill extends StatelessWidget {
  const TonePill({
    super.key,
    required this.label,
    this.tone = StateTone.brand,
  });

  final String label;
  final StateTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tone.background(colors),
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        label,
        maxLines: 1,
        style: context.text.labelSmall?.copyWith(
          color: tone.foreground(colors),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
