import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_context.dart';

class OtpBoxes extends StatelessWidget {
  const OtpBoxes({
    super.key,
    required this.length,
    required this.value,
    required this.hasError,
  });

  final int length;
  final String value;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(length, (index) {
          final isActive = !hasError && index == value.length;
          final isFilled = index < value.length;
          final borderColor = hasError
              ? colors.danger
              : isActive || isFilled
                  ? colors.brandBright
                  : colors.border;
          return Flexible(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.otpBoxWidth,
              ),
              height: AppSizes.otpBoxHeight,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isFilled && !hasError
                    ? colors.successSoft
                    : context.scheme.surface,
                borderRadius: AppRadius.mdAll,
                border: Border.all(
                  color: borderColor,
                  width: AppSizes.borderWidthField,
                ),
                boxShadow: isActive ? AppShadows.focus(colors) : null,
              ),
              child: Text(
                isFilled ? value[index] : '',
                style: context.text.headlineMedium?.copyWith(
                  fontSize: AppTypography.otp,
                  color: hasError ? colors.danger : colors.ink,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
