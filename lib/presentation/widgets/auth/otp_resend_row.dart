import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/duration_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../common/link_button.dart';

/// Countdown until a new code can be requested, then the resend link.
class OtpResendRow extends StatelessWidget {
  const OtpResendRow({
    super.key,
    required this.secondsLeft,
    required this.onResend,
  });

  final int secondsLeft;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    if (secondsLeft <= 0) {
      return Center(
        child: LinkButton(label: l10n.otpResendAction, onPressed: onResend),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.otpResendIn,
          style: context.text.bodyMedium?.copyWith(color: colors.mutedText),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          DurationFormatter.clock(secondsLeft),
          textDirection: TextDirection.ltr,
          style: context.text.titleMedium?.copyWith(color: colors.brand),
        ),
      ],
    );
  }
}
