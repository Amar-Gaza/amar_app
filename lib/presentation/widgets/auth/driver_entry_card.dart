import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../common/directional_icons.dart';
import '../common/icon_tile.dart';
import '../common/press_scale.dart';

/// Link from the customer sign-in to the driver sign-in.
class DriverEntryCard extends StatelessWidget {
  const DriverEntryCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return PressScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.surfaceSoft,
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: colors.disabled),
        ),
        child: Row(
          children: [
            IconTile(
              icon: LucideIcons.truck,
              size: AppSizes.squareButton,
              iconSize: AppSizes.iconSm,
              background: colors.onBrand,
              borderRadius: AppRadius.mdAll,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.authDriverTitle, style: context.text.titleMedium),
                  Text(l10n.authDriverSubtitle, style: context.text.bodySmall),
                ],
              ),
            ),
            Icon(
              DirectionalIcons.forward(context),
              size: AppSizes.iconXs,
              color: colors.subtleText,
            ),
          ],
        ),
      ),
    );
  }
}
