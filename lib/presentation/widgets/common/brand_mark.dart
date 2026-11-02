import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';

/// App logo tile. Shows a placeholder icon until [AppAssets.logo] is added.
class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.size = AppSizes.brandMarkSm,
    this.onGradient = false,
  });

  static const double _radiusRatio = 0.31;
  static const double _cornerRatio = 0.1;
  static const double _iconRatio = 0.5;

  final double size;

  /// White tile for gradient backgrounds such as the splash.
  final bool onGradient;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = Radius.circular(size * _radiusRatio);
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: onGradient ? colors.onBrand : null,
        gradient: onGradient ? null : colors.brandGradient,
        borderRadius: BorderRadius.only(
          topLeft: radius,
          topRight: radius,
          bottomRight: radius,
          bottomLeft: Radius.circular(size * _cornerRatio),
        ),
        boxShadow: AppShadows.button(colors),
      ),
      child: Image.asset(
        AppAssets.logo,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(
          LucideIcons.wrench,
          size: size * _iconRatio,
          color: onGradient ? colors.brand : colors.onBrand,
        ),
      ),
    );
  }
}
