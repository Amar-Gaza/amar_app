import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';

/// Amber count shown on the cart tab.
class NavBadge extends StatelessWidget {
  const NavBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      constraints: const BoxConstraints(minWidth: AppSizes.navBadge),
      height: AppSizes.navBadge,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.amber,
        borderRadius: BorderRadius.circular(AppSizes.navBadge / 2),
      ),
      child: Text(
        '$count',
        style: context.text.labelSmall?.copyWith(
          color: colors.onAmber,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
