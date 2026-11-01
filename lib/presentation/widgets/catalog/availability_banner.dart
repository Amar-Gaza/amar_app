import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/icon_tile.dart';
import '../common/state_tone.dart';

/// Open / closed state of a vendor with its preparation time.
class AvailabilityBanner extends StatelessWidget {
  const AvailabilityBanner({super.key, required this.vendor});

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final open = vendor.isOpenNow;
    final tone = open ? StateTone.success : StateTone.danger;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: tone.background(colors),
        borderRadius: AppRadius.lgAll,
      ),
      child: Row(
        children: [
          IconTile(
            icon: open ? LucideIcons.check : LucideIcons.clock,
            background: context.scheme.surface,
            foreground: tone.foreground(colors),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  open ? l10n.vendorOpenTitle : l10n.vendorClosedTitle,
                  style: context.text.titleLarge
                      ?.copyWith(color: tone.foreground(colors)),
                ),
                Text(
                  open
                      ? l10n.vendorPrepMinutes(vendor.prepMinutes)
                      : l10n.vendorClosedHint,
                  style: context.text.labelSmall
                      ?.copyWith(color: colors.mutedText),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.iconXs),
        ],
      ),
    );
  }
}
