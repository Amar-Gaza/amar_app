import 'package:flutter/material.dart';

import '../../../core/constants/app_defaults.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';

/// Mint rounded tile carrying the brand glyph.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = AppSizes.brandMarkSm});

  static const double _radiusRatio = 0.3;
  static const double _glyphRatio = 0.55;

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.accent,
        borderRadius: BorderRadius.circular(size * _radiusRatio),
      ),
      child: Text(
        AppDefaults.brandGlyph,
        style: TextStyle(
          color: colors.ink,
          fontSize: size * _glyphRatio,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}
