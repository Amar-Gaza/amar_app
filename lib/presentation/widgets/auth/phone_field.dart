import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_defaults.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../common/app_text_field.dart';

/// Phone number input with the dial code shown as a fixed segment.
class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.helper,
    required this.errorText,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String helper;
  final String? errorText;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) => AppTextField(
        controller: controller,
        label: label,
        hint: hint,
        helper: helper,
        errorText: errorText,
        keyboardType: TextInputType.phone,
        textDirection: TextDirection.ltr,
        maxLength: AppDefaults.phoneMaxDigits,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onSubmitted: onSubmitted,
        prefix: Container(
          margin: const EdgeInsetsDirectional.only(end: AppSpacing.md),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            border: BorderDirectional(
              end: BorderSide(
                color: context.appColors.border,
                width: AppSizes.borderWidth,
              ),
            ),
          ),
          child: Center(
            widthFactor: 1,
            child: Text(
              AppDefaults.dialCode,
              textDirection: TextDirection.ltr,
              style: context.text.titleSmall,
            ),
          ),
        ),
      );
}
