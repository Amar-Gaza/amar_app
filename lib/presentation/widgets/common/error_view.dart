import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/localization/error_message_resolver.dart';
import '../../../core/network/api_failure.dart';
import '../../../l10n/app_localizations.dart';
import 'state_tone.dart';
import 'state_view.dart';
import 'support_reference.dart';

/// Picks the offline, unavailable or generic API error state for a failure.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.failure,
    required this.onRetry,
    this.onSupport,
  });

  final ApiFailure failure;
  final VoidCallback onRetry;
  final VoidCallback? onSupport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (failure.isConnectivity) {
      return StateView(
        icon: LucideIcons.wifi,
        tone: StateTone.warning,
        showDot: true,
        title: l10n.stateOfflineTitle,
        message: l10n.stateOfflineMessage,
        primaryLabel: l10n.commonRetry,
        onPrimary: onRetry,
        footer: Text(
          l10n.stateOfflineFootnote,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      );
    }
    if (failure.isUnavailable) {
      return StateView(
        icon: LucideIcons.wrench,
        tone: StateTone.danger,
        code: failure.code,
        title: l10n.stateUnavailableTitle,
        message: l10n.stateUnavailableMessage,
        primaryLabel: l10n.commonRetry,
        onPrimary: onRetry,
        secondaryLabel: onSupport == null ? null : l10n.commonContactSupport,
        onSecondary: onSupport,
      );
    }
    final requestId = failure.requestId;
    return StateView(
      icon: LucideIcons.circleAlert,
      tone: StateTone.danger,
      code: failure.code,
      title: l10n.stateErrorTitle,
      message: ErrorMessageResolver.resolve(failure, l10n),
      primaryLabel: l10n.commonRetry,
      onPrimary: onRetry,
      footer: requestId == null
          ? null
          : SupportReference(
              label: l10n.stateSupportReference,
              reference: requestId,
            ),
    );
  }
}
