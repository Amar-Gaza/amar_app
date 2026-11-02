import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';
import 'map_stripes_painter.dart';

/// Decorative map with a pulsing pin. It shows no real location yet.
class MapPreview extends StatefulWidget {
  const MapPreview({super.key});

  @override
  State<MapPreview> createState() => _MapPreviewState();
}

class _MapPreviewState extends State<MapPreview>
    with SingleTickerProviderStateMixin {
  static const double _minScale = 0.3;
  static const double _maxScale = 1.5;
  static const double _pulseAlpha = 0.2;
  static const double _roadAlpha = 0.56;

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: AppDurations.mapPulse,
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ClipRRect(
      borderRadius: AppRadius.xlAll,
      child: Container(
        height: AppSizes.locationMapHeight,
        color: colors.brandSoft,
        child: CustomPaint(
          painter: MapStripesPainter(
            road: colors.onBrand.withValues(alpha: _roadAlpha),
            street: colors.accent,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              FadeTransition(
                opacity: ReverseAnimation(_pulse),
                child: ScaleTransition(
                  scale: Tween<double>(begin: _minScale, end: _maxScale)
                      .animate(_pulse),
                  child: Container(
                    width: AppSizes.mapPulseSize,
                    height: AppSizes.mapPulseSize,
                    decoration: BoxDecoration(
                      color: colors.brandBright.withValues(alpha: _pulseAlpha),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Icon(
                LucideIcons.mapPin,
                size: AppSizes.iconXl + AppSizes.iconSm,
                color: colors.brand,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
