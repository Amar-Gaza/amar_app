import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/launcher.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/dashed_painter.dart';
import 'route_stop.dart';

/// Pickup and drop-off of a driver order joined by a dashed line.
class RouteSteps extends StatelessWidget {
  const RouteSteps({
    super.key,
    required this.order,
    this.showDirections = false,
  });

  final DriverOrder order;

  /// Adds a button per stop that opens directions in the maps app.
  final bool showDirections;

  VoidCallback? _directions(Place place) {
    final lat = place.lat;
    final lng = place.lng;
    if (!showDirections || lat == null || lng == null) return null;
    return () => Launcher.map(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RouteStop(
          color: colors.brandBright,
          label: l10n.orderPickup,
          place: order.vendor?.name ??
              order.pickup.label ??
              l10n.orderPlaceUnknown,
          details: order.vendor == null ? null : order.pickup.label,
          directionsLabel: l10n.orderDirections,
          onDirections: _directions(order.pickup),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: AppSizes.routeDot / 2 - AppSizes.borderWidth,
          ),
          child: SizedBox(
            width: AppSizes.borderWidthActive,
            height: AppSizes.routeLine,
            child: RotatedBox(
              quarterTurns: 1,
              child: CustomPaint(
                painter: DashedPainter(
                  color: colors.subtleText,
                  strokeWidth: AppSizes.borderWidthActive,
                ),
              ),
            ),
          ),
        ),
        RouteStop(
          color: colors.amber,
          label: l10n.orderDropoff,
          place: order.dropoff.label ?? l10n.orderPlaceUnknown,
          details: order.dropoff.details,
          directionsLabel: l10n.orderDirections,
          onDirections: _directions(order.dropoff),
        ),
      ],
    );
  }
}
