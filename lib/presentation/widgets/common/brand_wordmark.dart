import 'package:flutter/material.dart';

import '../../../core/constants/app_defaults.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import 'brand_mark.dart';

/// Brand mark followed by the Arabic name and the Latin name.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({
    super.key,
    this.markSize = AppSizes.brandMarkMd,
    this.onDark = false,
  });

  static const double _latinSpacing = 2;

  final double markSize;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final nameColor = onDark ? colors.onInk : colors.ink;
    final latinColor = onDark ? colors.accent : colors.brand;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrandMark(size: markSize),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context).brandName,
              style: context.text.headlineLarge
                  ?.copyWith(color: nameColor, height: 1.1),
            ),
            Text(
              AppDefaults.brandLatin,
              style: context.text.labelSmall?.copyWith(
                color: latinColor,
                letterSpacing: _latinSpacing,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
