import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import 'brand_mark.dart';

/// Logo followed by the app name and its tagline.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({
    super.key,
    this.markSize = AppSizes.brandMarkMd,
    this.onDark = false,
  });

  static const double _nameSize = 19;
  static const double _nameHeight = 1.2;

  final double markSize;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrandMark(size: markSize, onGradient: onDark),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.brandName,
              style: context.text.headlineLarge?.copyWith(
                color: onDark ? colors.onBrand : colors.brand,
                fontSize: _nameSize,
                height: _nameHeight,
              ),
            ),
            Text(
              l10n.splashTagline,
              style: TextStyle(
                color: onDark ? colors.accent : colors.mutedText,
                fontSize: AppTypography.tiny,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
