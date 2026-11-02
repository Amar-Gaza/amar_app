import 'package:flutter/material.dart';

import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import 'auth_body_text.dart';

/// "We sent a code to" followed by the number in left-to-right order.
class OtpSentLine extends StatelessWidget {
  const OtpSentLine({super.key, required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context) => Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          AuthBodyText(AppLocalizations.of(context).otpSentTo),
          Text(
            phone,
            textDirection: TextDirection.ltr,
            style: context.text.titleMedium,
          ),
        ],
      );
}
