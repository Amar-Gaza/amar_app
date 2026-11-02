import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_defaults.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../common/app_text_field.dart';

/// Phone number input with the dial code fixed at the field's end.
class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.errorText,
    this.onSubmitted,
    this.enabled = true,
    this.showIcon = true,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? errorText;
  final VoidCallback? onSubmitted;
  final bool enabled;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      errorText: errorText,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      textDirection: TextDirection.ltr,
      textAlign: isRtl ? TextAlign.right : TextAlign.left,
      maxLength: AppDefaults.phoneMaxDigits,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onSubmitted: onSubmitted,
      prefixIcon: showIcon ? LucideIcons.phone : null,
      suffix: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Center(
          widthFactor: 1,
          child: Text(
            AppDefaults.dialCode,
            textDirection: TextDirection.ltr,
            style: context.text.titleMedium?.copyWith(
              color: context.appColors.mutedText,
            ),
          ),
        ),
      ),
    );
  }
}
