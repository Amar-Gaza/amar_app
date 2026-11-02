import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'nav_badge.dart';

/// Tab icon and label. The active tab's icon moves into the floating bubble.
class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge = 0,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = selected ? colors.brand : colors.subtleText;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedOpacity(
              opacity: selected ? 0 : 1,
              duration: AppDurations.dot,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, size: AppSizes.iconMd, color: color),
                  if (badge > 0)
                    PositionedDirectional(
                      top: -AppSpacing.sm,
                      end: -AppSpacing.md,
                      child: NavBadge(count: badge),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: context.text.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
