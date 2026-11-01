import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/hex_color.dart';
import '../../../data/models/masar/masar_models.dart';

/// Status label tinted with the color the server assigns to it.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  static const double _tintAlpha = 0.12;

  final Status status;

  @override
  Widget build(BuildContext context) {
    final color = HexColor.tryParse(status.color) ?? context.appColors.brand;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: _tintAlpha),
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        status.label,
        style: context.text.labelSmall?.copyWith(color: color),
      ),
    );
  }
}
