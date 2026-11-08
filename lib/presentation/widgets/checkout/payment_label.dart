import '../../../core/constants/api_query.dart';
import '../../../l10n/app_localizations.dart';

/// Display name of a payment method key from the app config.
String paymentLabel(AppLocalizations l10n, String key) => switch (key) {
      PaymentMethods.cashOnDelivery ||
      PaymentMethods.cash =>
        l10n.paymentCashOnDelivery,
      PaymentMethods.bankTransfer => l10n.paymentBankTransfer,
      _ => key,
    };
