import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.showMessage = false});

  final bool showMessage;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (showMessage) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                AppLocalizations.of(context).commonLoading,
                style: context.text.bodySmall,
              ),
            ],
          ],
        ),
      );
}
