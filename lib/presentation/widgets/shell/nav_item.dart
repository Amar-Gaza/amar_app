import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'nav_badge.dart';

/// Tab icon and label. With [floatingSelection] the active tab's icon is
/// hidden because the bar draws it in a raised bubble; its label stays.
class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge = 0,
    this.floatingSelection = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int badge;
  final bool floatingSelection;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = selected ? colors.brand : colors.subtleText;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            opacity: selected && floatingSelection ? 0 : 1,
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
          AnimatedDefaultTextStyle(
            duration: AppDurations.dot,
            style: (context.text.labelSmall ?? const TextStyle()).copyWith(
              color: color,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            ),
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
