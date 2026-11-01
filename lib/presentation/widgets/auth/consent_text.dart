import 'package:flutter/material.dart';

import '../../../core/theme/theme_context.dart';

/// Consent sentence with the terms and privacy names highlighted.
class ConsentText extends StatelessWidget {
  const ConsentText({
    super.key,
    required this.prefix,
    required this.terms,
    required this.separator,
    required this.privacy,
  });

  final String prefix;
  final String terms;
  final String separator;
  final String privacy;

  @override
  Widget build(BuildContext context) {
    final base =
        context.text.labelSmall?.copyWith(color: context.appColors.mutedText);
    final link = base?.copyWith(
      color: context.appColors.brand,
      fontWeight: FontWeight.w700,
    );
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: prefix),
          TextSpan(text: terms, style: link),
          TextSpan(text: separator),
          TextSpan(text: privacy, style: link),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
