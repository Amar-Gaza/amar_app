import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';

/// App logo. [AppAssets.logo] is already a rounded green tile with
/// transparent corners, so it is drawn as is, with no tile behind it.
class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.size = AppSizes.brandMarkSm,
    this.onGradient = false,
  });

  /// Corner radius of the rounded square inside the logo image.
  static const double _radiusRatio = 0.21;
  static const double _iconRatio = 0.5;

  final double size;

  /// Kept for callers on gradient backgrounds such as the splash; the logo
  /// looks the same on any background.
  final bool onGradient;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = BorderRadius.circular(size * _radiusRatio);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: AppShadows.button(colors),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Image.asset(
          AppAssets.logo,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => DecoratedBox(
            decoration: BoxDecoration(gradient: colors.brandGradient),
            child: Icon(
              LucideIcons.wrench,
              size: size * _iconRatio,
              color: colors.onBrand,
            ),
          ),
        ),
      ),
    );
  }
}
