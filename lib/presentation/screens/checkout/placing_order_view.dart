import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';

/// Shown while POST /orders runs (design 15).
class PlacingOrderView extends StatelessWidget {
  const PlacingOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: AppSizes.statusRing,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox.expand(
                    child: CircularProgressIndicator(
                      strokeWidth: AppSizes.loaderStroke,
                    ),
                  ),
                  Icon(LucideIcons.receiptText,
                      size: AppSizes.iconLg, color: colors.brand),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.placingTitle, style: context.text.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.placingMessage,
              textAlign: TextAlign.center,
              style: context.text.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
