import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/code_chip.dart';
import '../common/network_thumb.dart';
import '../common/state_tone.dart';

class VendorCard extends StatelessWidget {
  const VendorCard({super.key, required this.vendor, required this.onTap});

  final Vendor vendor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: AppSizes.vendorCardWidth,
      child: Material(
        color: context.scheme.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: context.appColors.border),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NetworkThumb(
                url: vendor.coverUrl ?? vendor.logoUrl,
                height: AppSizes.vendorCover,
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vendor.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.titleMedium,
                          ),
                          if (vendor.category != null)
                            Text(
                              vendor.category!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.labelSmall?.copyWith(
                                color: context.appColors.mutedText,
                              ),
                            ),
                        ],
                      ),
                    ),
                    CodeChip(
                      label: vendor.isOpenNow
                          ? l10n.vendorOpenNow
                          : l10n.vendorClosedNow,
                      tone: vendor.isOpenNow
                          ? StateTone.success
                          : StateTone.warning,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
