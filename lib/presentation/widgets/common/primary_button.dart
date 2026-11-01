import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  static const double _shadowAlpha = 0.25;
  static const double _shadowBlur = 18;

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final enabled = onPressed != null && !isLoading;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.mdAll,
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: colors.brand.withValues(alpha: _shadowAlpha),
                  blurRadius: _shadowBlur,
                  offset: const Offset(0, AppSpacing.sm),
                ),
              ]
            : null,
      ),
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: AppSizes.iconSm,
                height: AppSizes.iconSm,
                child: CircularProgressIndicator(
                  strokeWidth: AppSizes.loaderStroke,
                  color: colors.onBrand,
                ),
              )
            : Text(label),
      ),
    );
  }
}
