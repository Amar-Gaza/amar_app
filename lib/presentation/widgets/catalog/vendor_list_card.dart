import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/code_chip.dart';
import '../common/directional_icons.dart';
import '../common/network_thumb.dart';
import '../common/state_tone.dart';
import 'vendor_meta_line.dart';

/// Vendor row: thumbnail, open state, name, category and quick facts.
class VendorListCard extends StatelessWidget {
  const VendorListCard({super.key, required this.vendor, required this.onTap});

  final Vendor vendor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Material(
      color: context.scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgAll,
        side: BorderSide(color: colors.border),
      ),
      child: InkWell(
        borderRadius: AppRadius.lgAll,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: AppRadius.mdAll,
                child: SizedBox.square(
                  dimension: AppSizes.productImage,
                  child: NetworkThumb(url: vendor.logoUrl ?? vendor.coverUrl),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CodeChip(
                      label: vendor.isOpenNow
                          ? l10n.vendorOpenNow
                          : l10n.vendorClosedNow,
                      tone: vendor.isOpenNow
                          ? StateTone.success
                          : StateTone.danger,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      vendor.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.titleMedium,
                    ),
                    if (vendor.category != null)
                      Text(
                        vendor.category!,
                        style: context.text.labelSmall
                            ?.copyWith(color: colors.mutedText),
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    VendorMetaLine(
                      icon: LucideIcons.star,
                      iconColor: colors.warning,
                      text: l10n.vendorRating(
                        vendor.rating.average.toStringAsFixed(1),
                        vendor.rating.count,
                      ),
                    ),
                    if (vendor.distanceKm != null)
                      VendorMetaLine(
                        icon: LucideIcons.mapPin,
                        text: l10n.vendorDistance(
                          vendor.distanceKm!.toStringAsFixed(1),
                        ),
                      ),
                    VendorMetaLine(
                      icon: LucideIcons.clock,
                      text: l10n.vendorPrepMinutes(vendor.prepMinutes),
                    ),
                  ],
                ),
              ),
              Icon(
                DirectionalIcons.forward(context),
                color: colors.mutedText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
