import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../common/dashed_painter.dart';

/// Home placeholder while the driver is offline.
class DriverOfflineCard extends StatelessWidget {
  const DriverOfflineCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return CustomPaint(
      painter: DashedPainter(
        color: colors.subtleText,
        radius: AppRadius.sheet,
        strokeWidth: AppSizes.borderWidthField,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.page,
          vertical: AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceSoft,
          borderRadius: AppRadius.sheetAll,
        ),
        child: Column(
          children: [
            Container(
              width: AppSizes.iconTileLg,
              height: AppSizes.iconTileLg,
              decoration: BoxDecoration(
                color: context.scheme.surface,
                borderRadius: AppRadius.lgAll,
                boxShadow: AppShadows.card(colors),
              ),
              child: Icon(
                LucideIcons.power,
                size: AppSizes.iconMd,
                color: colors.mutedText,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.driverOfflineTitle, style: context.text.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.driverOfflineMessage,
              textAlign: TextAlign.center,
              style: context.text.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
