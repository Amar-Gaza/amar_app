import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_context.dart';
import 'press_scale.dart';

/// Short solid brand button used inside cards ("Accept order").
class CompactButton extends StatelessWidget {
  const CompactButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      child: PressScale(
        onTap: onPressed,
        child: Container(
          height: AppSizes.buttonHeightSm,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled ? colors.brand : colors.disabled,
            borderRadius: AppRadius.buttonAll,
          ),
          child: Text(
            label,
            style: context.text.labelMedium?.copyWith(
              color: colors.onBrand,
              fontSize: AppTypography.link,
            ),
          ),
        ),
      ),
    );
  }
}
