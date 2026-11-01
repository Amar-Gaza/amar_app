import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/launcher.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/icon_tile.dart';
import 'section_card.dart';

/// Pickup and drop-off places, optionally with a directions button.
class RouteCard extends StatelessWidget {
  const RouteCard({
    super.key,
    required this.pickup,
    required this.dropoff,
    this.pickupName,
    this.showDirections = false,
  });

  final Place pickup;
  final Place dropoff;
  final String? pickupName;
  final bool showDirections;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Widget row(IconData icon, String label, Place place, String? name) {
      final title = name ?? place.label ?? l10n.orderPlaceUnknown;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            IconTile(
              icon: icon,
              size: AppSizes.iconTileSm,
              iconSize: AppSizes.iconSm,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.text.labelSmall
                        ?.copyWith(color: context.appColors.mutedText),
                  ),
                  Text(title, style: context.text.titleSmall),
                  if (place.details != null)
                    Text(place.details!, style: context.text.labelSmall),
                ],
              ),
            ),
            if (showDirections && place.lat != null && place.lng != null)
              IconButton.filled(
                tooltip: l10n.orderDirections,
                onPressed: () => Launcher.map(place.lat!, place.lng!),
                style: IconButton.styleFrom(
                  backgroundColor: context.appColors.ink,
                ),
                icon: Icon(LucideIcons.map, color: context.appColors.onInk),
              ),
          ],
        ),
      );
    }

    return SectionCard(
      title: l10n.orderRoute,
      children: [
        row(LucideIcons.store, l10n.orderPickup, pickup, pickupName),
        row(LucideIcons.house, l10n.orderDropoff, dropoff, null),
      ],
    );
  }
}
