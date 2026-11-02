import 'package:flutter/material.dart';

import '../../../core/localization/price_label.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/catalog/provider_entry.dart';
import '../../../l10n/app_localizations.dart';
import '../common/state_tone.dart';
import '../common/surface_card.dart';
import '../common/tone_pill.dart';
import 'provider_logo.dart';

/// Vendor name and location with one of its products or services.
class ProviderCard extends StatelessWidget {
  const ProviderCard({super.key, required this.entry, required this.onTap});

  final ProviderEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final vendor = entry.vendor;
    final address = vendor.address?.trim() ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: SurfaceCard(
        onTap: onTap,
        child: Row(
          children: [
            ProviderLogo(name: vendor.name, url: vendor.logoUrl),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendor.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleSmall,
                  ),
                  if (address.isNotEmpty)
                    Text(
                      address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall,
                    ),
                  Text(
                    entry.item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall
                        ?.copyWith(color: context.appColors.ink),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TonePill(label: PriceLabel.of(entry.item, l10n)),
                if (!vendor.isOpenNow) ...[
                  const SizedBox(height: AppSpacing.xs),
                  TonePill(
                    label: l10n.vendorClosedNow,
                    tone: StateTone.danger,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
