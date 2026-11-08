import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'nav_badge.dart';
import 'nav_bar_painter.dart';
import 'nav_item.dart';
import 'nav_motion.dart';

/// Floating pill bar shared by the customer and driver shells. The active
/// tab's icon sits in a raised bubble that hops to the next tab.
class CurvedBottomNav extends StatefulWidget {
  const CurvedBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelect,
    this.badges = const [],
  });

  final List<(IconData, String)> items;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  /// Optional count per tab, same order as [items]; 0 hides the badge.
  final List<int> badges;

  @override
  State<CurvedBottomNav> createState() => _CurvedBottomNavState();
}

class _CurvedBottomNavState extends State<CurvedBottomNav>
    with SingleTickerProviderStateMixin {
  static const double _pillShadowAlpha = 0.12;

  late final AnimationController _motion;
  late NavMotionFrame _start;
  late int _target;
  late int _originIcon;

  bool _reduceMotion = false;

  NavMotionFrame get _frame => NavMotion.sample(
        start: _start,
        target: _target.toDouble(),
        progress: _motion.value,
      );

  int get _visibleIndex =>
      _motion.value < NavMotion.iconSwitchAt ? _originIcon : _target;

  int _badgeAt(int i) => i < widget.badges.length ? widget.badges[i] : 0;

  @override
  void initState() {
    super.initState();
    _target = widget.currentIndex;
    _originIcon = widget.currentIndex;
    _start = NavMotionFrame.rest(widget.currentIndex.toDouble());
    _motion = AnimationController(
      vsync: this,
      duration: NavMotion.duration,
      value: 1,
      animationBehavior: AnimationBehavior.preserve,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (_reduceMotion) {
      _motion.stop();
      _start = NavMotionFrame.rest(_target.toDouble());
      _originIcon = _target;
      _motion.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant CurvedBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex == widget.currentIndex) return;

    // Continue from the rendered position when the user taps rapidly.
    final start = _frame;
    final icon = _visibleIndex;
    _motion.stop();
    _start = start;
    _originIcon = icon;
    _target = widget.currentIndex;

    if (_reduceMotion) {
      _start = NavMotionFrame.rest(_target.toDouble());
      _motion.value = 1;
    } else {
      _motion.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final items = widget.items;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final bottom = math.max(
      MediaQuery.paddingOf(context).bottom,
      AppSpacing.md,
    );

    return SizedBox(
      height: AppSizes.navBarTop + AppSizes.navHeight + bottom,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSizes.navBarTop,
          AppSpacing.lg,
          bottom,
        ),
        child: LayoutBuilder(
          builder: (_, constraints) {
            final tabWidth = constraints.maxWidth / items.length;
            return AnimatedBuilder(
              animation: _motion,
              builder: (_, child) {
                final frame = _frame;
                final slot = frame.index + 0.5;
                final center = (isRtl ? items.length - slot : slot) * tabWidth;
                final visible = _visibleIndex;
                final badge = _badgeAt(visible);

                final air = (frame.lift / NavMotion.jumpHeight).clamp(0.0, 1.0);

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: NavBarPainter(
                          center: center,
                          bubbleCenterY:
                              NavMotion.restTop + AppSizes.navBubble / 2,
                          bubbleRadius: AppSizes.navBubble / 2,
                          raise: 1 - air,
                          color: context.scheme.surface,
                          shadow: colors.brand.withValues(
                            alpha: _pillShadowAlpha,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(child: child!),
                    Positioned(
                      top: NavMotion.restTop - frame.lift,
                      left: center - AppSizes.navBubble / 2,
                      child: IgnorePointer(
                        child: ExcludeSemantics(
                          child: Transform.scale(
                            scaleX: frame.scaleX,
                            scaleY: frame.scaleY,
                            child: _bubble(
                              context,
                              items[visible].$1,
                              badge,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              child: Row(
                children: [
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      child: Semantics(
                        selected: i == widget.currentIndex,
                        button: true,
                        child: NavItem(
                          icon: items[i].$1,
                          label: items[i].$2,
                          selected: i == widget.currentIndex,
                          floatingSelection: true,
                          badge: _badgeAt(i),
                          onTap: () => widget.onSelect(i),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _bubble(BuildContext context, IconData icon, int badge) {
    final colors = context.appColors;
    return Container(
      width: AppSizes.navBubble,
      height: AppSizes.navBubble,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: colors.brandGradient,
        boxShadow: AppShadows.button(colors),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedSwitcher(
            duration: _reduceMotion ? Duration.zero : AppDurations.press,
            child: Icon(
              icon,
              key: ValueKey(icon),
              size: AppSizes.iconMd,
              color: colors.onBrand,
            ),
          ),
          if (badge > 0)
            Positioned(top: -2, right: -2, child: NavBadge(count: badge)),
        ],
      ),
    );
  }
}
