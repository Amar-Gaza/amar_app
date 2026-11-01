import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/code_chip.dart';
import '../common/icon_tile.dart';
import '../common/network_thumb.dart';
import '../common/state_tone.dart';
import 'cover_back_button.dart';
import 'vendor_stats.dart';

/// Cover image, identity, quick stats and address of a vendor.
class VendorHeader extends StatelessWidget {
  const VendorHeader({super.key, required this.vendor});

  static const double _coverHeight = 220;

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final initial =
        vendor.name.trim().isEmpty ? '' : vendor.name.trim().characters.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            NetworkThumb(
              url: vendor.coverUrl ?? vendor.logoUrl,
              height: _coverHeight,
            ),
            const CoverBackButton(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: AppSizes.iconTileLg,
                    height: AppSizes.iconTileLg,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.accent,
                      borderRadius: AppRadius.lgAll,
                    ),
                    child: Text(initial, style: context.text.headlineLarge),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(vendor.name, style: context.text.headlineSmall),
                        if (vendor.category != null)
                          Text(
                            vendor.category!,
                            style: context.text.labelSmall
                                ?.copyWith(color: colors.mutedText),
                          ),
                      ],
                    ),
                  ),
                  CodeChip(
                    label: vendor.isOpenNow
                        ? l10n.vendorOpenNow
                        : l10n.vendorClosedNow,
                    tone:
                        vendor.isOpenNow ? StateTone.success : StateTone.danger,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              VendorStats(vendor: vendor),
              if (vendor.address != null || vendor.phone != null) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.lgAll,
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(LucideIcons.mapPin, color: colors.brand),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.vendorAddress,
                              style: context.text.titleSmall,
                            ),
                            Text(
                              vendor.address ?? l10n.vendorAddressUnknown,
                              style: context.text.labelSmall
                                  ?.copyWith(color: colors.mutedText),
                            ),
                          ],
                        ),
                      ),
                      if (vendor.phone != null)
                        Column(
                          children: [
                            const IconTile(
                              icon: LucideIcons.phone,
                              size: AppSizes.iconXl,
                              iconSize: AppSizes.iconSm,
                            ),
                            SelectableText(
                              vendor.phone!,
                              textDirection: TextDirection.ltr,
                              style: context.text.labelSmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
