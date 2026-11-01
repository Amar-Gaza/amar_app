import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSizes.navIndicatorWidth,
              height: AppSizes.navIndicatorHeight,
              decoration: BoxDecoration(
                color: selected ? colors.brandSoft : null,
                borderRadius: AppRadius.pillAll,
              ),
              child: Icon(
                icon,
                size: AppSizes.iconSm,
                color: selected ? colors.brand : colors.subtleText,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: context.text.labelSmall?.copyWith(
                color: selected ? colors.ink : colors.mutedText,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
