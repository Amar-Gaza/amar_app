import 'package:flutter/material.dart';

import '../../../core/theme/theme_context.dart';

/// Muted paragraph used under auth titles.
class AuthBodyText extends StatelessWidget {
  const AuthBodyText(this.text, {super.key});

  static const double _lineHeight = 1.8;

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: context.text.bodyMedium?.copyWith(
          color: context.appColors.mutedText,
          height: _lineHeight,
        ),
      );
}
