import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'field_label.dart';
import 'focus_glow.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.helper,
    this.errorText,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.showCounter = false,
    this.prefix,
    this.prefixIcon,
    this.textDirection,
    this.onSubmitted,
    this.obscure = false,
    this.suffix,
    this.enabled = true,
    this.textAlign = TextAlign.start,
  });

  final TextEditingController controller;
  final String hint;
  final String? label;
  final String? helper;
  final String? errorText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool showCounter;
  final Widget? prefix;
  final IconData? prefixIcon;
  final TextDirection? textDirection;
  final VoidCallback? onSubmitted;
  final bool obscure;
  final Widget? suffix;
  final bool enabled;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: controller,
      obscureText: obscure,
      enabled: enabled,
      textAlign: textAlign,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      textDirection: textDirection,
      onSubmitted: onSubmitted == null ? null : (_) => onSubmitted!(),
      buildCounter: showCounter
          ? null
          : (_, {required currentLength, required isFocused, maxLength}) =>
              null,
      decoration: InputDecoration(
        hintText: hint,
        hintTextDirection: textDirection,
        helperText: helper,
        helperStyle: context.text.labelSmall
            ?.copyWith(color: context.appColors.mutedText),
        errorText: errorText,
        prefixIcon: prefix ?? (prefixIcon == null ? null : Icon(prefixIcon)),
        suffixIcon: suffix,
        counterStyle: context.text.labelSmall
            ?.copyWith(color: context.appColors.mutedText),
      ),
    );
    final glowing = FocusGlow(borderRadius: AppRadius.mdAll, child: field);
    if (label == null) return glowing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldLabel(label!),
        glowing,
        const SizedBox(height: AppSpacing.xs),
      ],
    );
  }
}
