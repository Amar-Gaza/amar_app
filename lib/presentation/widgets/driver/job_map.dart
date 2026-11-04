import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_defaults.dart';
import '../../../core/constants/app_env.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../auth/map_stripes_painter.dart';

/// Map behind the job sheet: pickup and drop-off markers when maps are
/// configured and the places have coordinates, otherwise a drawn map.
class JobMap extends StatelessWidget {
  const JobMap({super.key, required this.pickup, required this.dropoff});

  static const double _roadAlpha = 0.56;
  static const double _boundsPadding = 64;
  static const String _pickupId = 'pickup';
  static const String _dropoffId = 'dropoff';

  final Place pickup;
  final Place dropoff;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final points = [
      for (final p in [pickup, dropoff])
        if (p.lat != null && p.lng != null) LatLng(p.lat!, p.lng!),
    ];
    if (!AppEnv.hasMaps || points.isEmpty) {
      return ColoredBox(
        color: colors.brandSoft,
        child: CustomPaint(
          painter: MapStripesPainter(
            road: colors.onBrand.withValues(alpha: _roadAlpha),
            street: colors.accent,
          ),
          child: Center(
            child: Icon(
              LucideIcons.mapPin,
              size: AppSizes.iconXl,
              color: colors.brand,
            ),
          ),
        ),
      );
    }
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: points.first,
        zoom: AppDefaults.mapZoom,
      ),
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      markers: {
        if (pickup.lat != null && pickup.lng != null)
          Marker(
            markerId: const MarkerId(_pickupId),
            position: LatLng(pickup.lat!, pickup.lng!),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        if (dropoff.lat != null && dropoff.lng != null)
          Marker(
            markerId: const MarkerId(_dropoffId),
            position: LatLng(dropoff.lat!, dropoff.lng!),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange,
            ),
          ),
      },
      polylines: {
        if (points.length == 2)
          Polyline(
            polylineId: const PolylineId(_pickupId),
            points: points,
            color: colors.brandBright,
            width: AppSizes.routeDotBorder.toInt(),
            patterns: [
              PatternItem.dash(AppSizes.routeLine),
              PatternItem.gap(AppSizes.dashGap * 2),
            ],
          ),
      },
      onMapCreated: (map) {
        if (points.length < 2) return;
        final a = points.first;
        final b = points.last;
        map.moveCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(
                a.latitude < b.latitude ? a.latitude : b.latitude,
                a.longitude < b.longitude ? a.longitude : b.longitude,
              ),
              northeast: LatLng(
                a.latitude > b.latitude ? a.latitude : b.latitude,
                a.longitude > b.longitude ? a.longitude : b.longitude,
              ),
            ),
            _boundsPadding,
          ),
        );
      },
    );
  }
}
