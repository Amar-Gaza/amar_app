import 'package:flutter/material.dart';

import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';

/// One line under the status chip saying what the status means for the
/// customer and who acts next. Hidden for statuses that need no hint.
class StatusHint extends StatelessWidget {
  const StatusHint({super.key, required this.statusKey});

  final String statusKey;

  static String? textFor(AppLocalizations l10n, String key) => switch (key) {
        StatusKeys.awaitingPricing => l10n.orderHintAwaitingPricing,
        StatusKeys.priced => l10n.orderHintPriced,
        StatusKeys.awaitingPayment => l10n.orderHintAwaitingPayment,
        StatusKeys.paymentReview => l10n.orderHintPaymentReview,
        StatusKeys.awaitingVendor => l10n.orderHintAwaitingVendor,
        StatusKeys.preparing => l10n.orderHintPreparing,
        StatusKeys.pending => l10n.orderHintPending,
        StatusKeys.accepted => l10n.orderHintAccepted,
        StatusKeys.pickedUp => l10n.orderHintPickedUp,
        StatusKeys.onTheWay => l10n.orderHintOnTheWay,
        StatusKeys.arrived => l10n.orderHintArrived,
        StatusKeys.serviceRequested => l10n.orderHintServiceRequested,
        StatusKeys.serviceInspection => l10n.orderHintServiceInspection,
        StatusKeys.serviceQuoted => l10n.orderHintServiceQuoted,
        StatusKeys.serviceScheduled => l10n.orderHintServiceScheduled,
        StatusKeys.technicianOnWay => l10n.orderHintTechnicianOnWay,
        StatusKeys.serviceInProgress => l10n.orderHintServiceInProgress,
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    final text = textFor(AppLocalizations.of(context), statusKey);
    if (text == null) return const SizedBox.shrink();
    return Text(
      text,
      style:
          context.text.bodySmall?.copyWith(color: context.appColors.mutedText),
    );
  }
}
