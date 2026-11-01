import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';

/// Rating, preparation time and distance in one tinted strip.
class VendorStats extends StatelessWidget {
  const VendorStats({super.key, required this.vendor});

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final stats = <(IconData, String, String)>[
      (
        LucideIcons.star,
        vendor.rating.average.toStringAsFixed(1),
        l10n.vendorRatingsCount(vendor.rating.count),
      ),
      (
        LucideIcons.clock,
        l10n.vendorMinutesShort(vendor.prepMinutes),
        l10n.vendorPrepLabel,
      ),
      if (vendor.distanceKm != null)
        (
          LucideIcons.mapPin,
          l10n.vendorDistance(vendor.distanceKm!.toStringAsFixed(1)),
          l10n.vendorDistanceLabel,
        ),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceSoft,
        borderRadius: AppRadius.lgAll,
      ),
      child: Row(
        children: [
          for (final (icon, value, label) in stats)
            Expanded(
              child: Column(
                children: [
                  Icon(icon, size: AppSizes.iconSm, color: colors.brand),
                  const SizedBox(height: AppSpacing.xs),
                  Text(value, style: context.text.titleSmall),
                  Text(
                    label,
                    style: context.text.labelSmall
                        ?.copyWith(color: colors.mutedText),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
