import 'package:flutter/material.dart';

import '../../../core/localization/error_message_resolver.dart';
import '../../../core/network/api_failure.dart';
import '../../../l10n/app_localizations.dart';
import 'info_banner.dart';

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.failure});

  final ApiFailure failure;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InfoBanner(
      title: l10n.commonErrorTitle,
      message: ErrorMessageResolver.resolve(failure, l10n),
    );
  }
}
