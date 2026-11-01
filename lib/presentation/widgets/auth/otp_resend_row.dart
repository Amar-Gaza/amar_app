import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/duration_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../common/link_button.dart';

/// Countdown on one side, resend action on the other.
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
    final canResend = secondsLeft <= 0;
    return Row(
      children: [
        Icon(LucideIcons.clock, size: AppSizes.iconXs, color: colors.mutedText),
        const SizedBox(width: AppSpacing.xs),
        if (!canResend) ...[
          Text(l10n.otpResendWithin,
              style:
                  context.text.labelSmall?.copyWith(color: colors.mutedText)),
          const SizedBox(width: AppSpacing.xs),
          Text(
            DurationFormatter.clock(secondsLeft),
            textDirection: TextDirection.ltr,
            style: context.text.labelMedium,
          ),
        ],
        const Spacer(),
        LinkButton(
          label: l10n.otpResend,
          onPressed: canResend ? onResend : null,
        ),
      ],
    );
  }
}
