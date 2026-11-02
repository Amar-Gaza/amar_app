import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';
import 'press_scale.dart';

/// Full-width gradient action with loading and disabled states.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final enabled = onPressed != null && !isLoading;
    return Semantics(
      button: true,
      enabled: enabled,
      child: PressScale(
        onTap: enabled ? onPressed : null,
        child: Container(
          width: double.infinity,
          height: AppSizes.buttonHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled ? null : colors.disabled,
            gradient: enabled ? colors.brandGradient : null,
            borderRadius: AppRadius.buttonAll,
            boxShadow: enabled ? AppShadows.button(colors) : null,
          ),
          child: isLoading
              ? SizedBox(
                  width: AppSizes.iconSm,
                  height: AppSizes.iconSm,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSizes.loaderStroke,
                    color: colors.onBrand,
                  ),
                )
              : Text(
                  label,
                  style: context.text.titleLarge?.copyWith(
                    color: colors.onBrand,
                  ),
                ),
        ),
      ),
    );
  }
}
