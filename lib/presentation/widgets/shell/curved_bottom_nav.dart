import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';
import 'nav_bar_painter.dart';
import 'nav_item.dart';

/// Notched bar with a floating bubble on the active tab, for shells
/// without badges (driver app). Same look as the customer bar.
class CurvedBottomNav extends StatelessWidget {
  const CurvedBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelect,
  });

  static const double _shadowAlpha = 0.11;

  final List<(IconData, String)> items;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return SizedBox(
      height: AppSizes.navHeight + bottomInset,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final tabWidth = constraints.maxWidth / items.length;
          final slot = currentIndex + 0.5;
          final target = (isRtl ? items.length - slot : slot) * tabWidth;
          return TweenAnimationBuilder<double>(
            tween: Tween(end: target),
            duration: AppDurations.navSlide,
            curve: Curves.easeOutCubic,
            builder: (_, center, child) => Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: NavBarPainter(
                      center: center,
                      color: context.scheme.surface,
                      shadow: colors.brand.withValues(alpha: _shadowAlpha),
                    ),
                  ),
                ),
                child!,
                Positioned(
                  top: 0,
                  left: center - AppSizes.navBubble / 2,
                  child: IgnorePointer(
                    child: Container(
                      width: AppSizes.navBubble,
                      height: AppSizes.navBubble,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: colors.brandGradient,
                        boxShadow: AppShadows.button(colors),
                      ),
                      child: Icon(
                        items[currentIndex].$1,
                        size: AppSizes.iconMd,
                        color: colors.onBrand,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      child: NavItem(
                        icon: items[i].$1,
                        label: items[i].$2,
                        selected: i == currentIndex,
                        floatingSelection: true,
                        onTap: () => onSelect(i),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
