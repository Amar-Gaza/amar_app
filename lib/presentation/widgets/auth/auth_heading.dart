import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Title and supporting line at the top of auth forms.
class AuthHeading extends StatelessWidget {
  const AuthHeading({super.key, required this.title, required this.subtitle});

  final String title;

  /// A widget so the OTP screen can highlight the phone number.
  final Widget subtitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.text.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          subtitle,
        ],
      );
}
