import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';

/// Empty state of the available orders list on the driver home.
class NoAvailableOrders extends StatelessWidget {
  const NoAvailableOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.page),
      child: Column(
        children: [
          Container(
            width: AppSizes.statusIllustration,
            height: AppSizes.statusIllustration,
            decoration: BoxDecoration(
              color: colors.surfaceSoft,
              borderRadius: AppRadius.illustrationAll,
            ),
            child: Icon(
              LucideIcons.shoppingBag,
              size: AppSizes.iconXl,
              color: colors.brand,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.driverNoAvailableTitle, style: context.text.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.driverNoAvailableHint,
            textAlign: TextAlign.center,
            style: context.text.bodySmall,
          ),
        ],
      ),
    );
  }
}
