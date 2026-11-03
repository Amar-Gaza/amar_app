import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';

/// Icon, value and caption inside the earnings hero stats strip.
class HeroStat extends StatelessWidget {
  const HeroStat({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSizes.iconXs, color: colors.onBrand),
        Text(
          value,
          maxLines: 1,
          style: context.text.headlineSmall?.copyWith(color: colors.onBrand),
        ),
        Text(
          label,
          maxLines: 1,
          style: context.text.labelSmall?.copyWith(color: colors.onBrand),
        ),
      ],
    );
  }
}
