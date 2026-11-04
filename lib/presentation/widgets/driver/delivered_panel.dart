import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../common/primary_button.dart';

/// Success content of the job sheet after delivery.
class DeliveredPanel extends StatelessWidget {
  const DeliveredPanel({
    super.key,
    required this.earning,
    required this.onDone,
  });

  final String? earning;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final amount = earning;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Container(
            width: AppSizes.statusIllustration,
            height: AppSizes.statusIllustration,
            decoration: BoxDecoration(
              color: colors.successSoft,
              borderRadius: AppRadius.illustrationAll,
            ),
            child: Icon(
              LucideIcons.circleCheck,
              size: AppSizes.iconXl,
              color: colors.success,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.driverDeliveredTitle,
          textAlign: TextAlign.center,
          style: context.text.headlineMedium,
        ),
        if (amount != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.driverDeliveredMessage(amount),
            textAlign: TextAlign.center,
            style: context.text.bodySmall,
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(label: l10n.successBackHome, onPressed: onDone),
      ],
    );
  }
}
