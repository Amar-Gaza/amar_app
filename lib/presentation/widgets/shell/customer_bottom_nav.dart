import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/cart_controller.dart';
import '../../../controllers/customer/shell_controller.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import 'nav_badge.dart';
import 'nav_bar_painter.dart';
import 'nav_item.dart';
import 'nav_motion.dart';

/// The active bubble hops to the selected tab and lands on a liquid surface.
class CustomerBottomNav extends StatefulWidget {
  const CustomerBottomNav({
    super.key,
    required this.current,
    required this.onSelect,
  });

  final CustomerTab current;
  final ValueChanged<CustomerTab> onSelect;

  @override
  State<CustomerBottomNav> createState() =>
      _CustomerBottomNavState();
}

class _CustomerBottomNavState
    extends State<CustomerBottomNav>
    with SingleTickerProviderStateMixin {
  static const double _shadowAlpha = 0.11;
  static const double _highlightAlpha = 0.16;
  static const double _highlightWidth = 0.42;
  static const double _highlightHeight = 0.18;

  late final AnimationController _motion;
  late NavMotionFrame _start;
  late CustomerTab _targetTab;
  late CustomerTab _originIcon;

  bool _reduceMotion = false;

  NavMotionFrame get _frame => NavMotion.sample(
    start: _start,
    target: _targetTab.index.toDouble(),
    progress: _motion.value,
  );

  CustomerTab get _visibleTab =>
      _motion.value < NavMotion.iconSwitchAt
          ? _originIcon
          : _targetTab;

  @override
  void initState() {
    super.initState();

    _targetTab = widget.current;
    _originIcon = widget.current;

    _start = NavMotionFrame.rest(
      widget.current.index.toDouble(),
    );

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

    _reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ??
            false;

    if (_reduceMotion) {
      _motion.stop();

      _start = NavMotionFrame.rest(
        _targetTab.index.toDouble(),
      );

      _originIcon = _targetTab;
      _motion.value = 1;
    }
  }

  @override
  void didUpdateWidget(
      covariant CustomerBottomNav oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.current == widget.current) return;

    // Continue from the rendered position when the user taps rapidly.
    final start = _frame;
    final icon = _visibleTab;

    _motion.stop();

    _start = start;
    _originIcon = icon;
    _targetTab = widget.current;

    if (_reduceMotion) {
      _start = NavMotionFrame.rest(
        _targetTab.index.toDouble(),
      );

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
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final cart = Get.find<CartController>();

    final isRtl =
        Directionality.of(context) == TextDirection.rtl;

    final items = <(CustomerTab, IconData, String)>[
      (
      CustomerTab.home,
      LucideIcons.house,
      l10n.navHome,
      ),
      (
      CustomerTab.orders,
      LucideIcons.clipboardList,
      l10n.navOrders,
      ),
      (
      CustomerTab.cart,
      LucideIcons.shoppingCart,
      l10n.navCart,
      ),
      (
      CustomerTab.account,
      LucideIcons.user,
      l10n.navAccount,
      ),
    ];

    final bottomInset =
        MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      height: AppSizes.navHeight + bottomInset,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final tabWidth =
              constraints.maxWidth / items.length;

          return AnimatedBuilder(
            animation: _motion,
            builder: (_, child) {
              final frame = _frame;
              final slot = frame.index + 0.5;

              final center =
                  (isRtl ? items.length - slot : slot) *
                      tabWidth;

              final visibleTab = _visibleTab;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: NavBarPainter(
                        center: center,
                        color: context.scheme.surface,
                        shadow: colors.brand.withValues(
                          alpha: _shadowAlpha,
                        ),
                        waterColor: colors.brandBright,
                        lift: frame.lift,
                        ripple: frame.ripple,
                      ),
                    ),
                  ),
                  child!,
                  Positioned(
                    top: -frame.lift,
                    left:
                    center - AppSizes.navBubble / 2,
                    child: IgnorePointer(
                      child: ExcludeSemantics(
                        child: Transform.scale(
                          scaleX: frame.scaleX,
                          scaleY: frame.scaleY,
                          child: Container(
                            width: AppSizes.navBubble,
                            height: AppSizes.navBubble,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient:
                              colors.brandGradient,
                              boxShadow:
                              AppShadows.button(colors),
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment:
                                  const Alignment(
                                    -0.35,
                                    -0.65,
                                  ),
                                  child: Container(
                                    width:
                                    AppSizes.navBubble *
                                        _highlightWidth,
                                    height:
                                    AppSizes.navBubble *
                                        _highlightHeight,
                                    decoration:
                                    BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                        AppSizes.navBubble,
                                      ),
                                      color: colors
                                          .onBrand
                                          .withValues(
                                        alpha:
                                        _highlightAlpha,
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedSwitcher(
                                  duration:
                                  _reduceMotion
                                      ? Duration.zero
                                      : AppDurations.press,
                                  child: Icon(
                                    items[visibleTab.index]
                                        .$2,
                                    key: ValueKey(
                                      visibleTab,
                                    ),
                                    size: AppSizes.iconMd,
                                    color: colors.onBrand,
                                  ),
                                ),
                                if (visibleTab ==
                                    CustomerTab.cart)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Obx(
                                          () => cart.count > 0
                                          ? NavBadge(
                                        count:
                                        cart.count,
                                      )
                                          : const SizedBox.shrink(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            child: Padding(
              padding: EdgeInsets.only(
                bottom: bottomInset,
              ),
              child: Row(
                children: [
                  for (final (tab, icon, label) in items)
                    Expanded(
                      child: Obx(() {
                        final count = cart.count;

                        return Semantics(
                          selected:
                          tab == widget.current,
                          button: true,
                          child: NavItem(
                            icon: icon,
                            label: label,
                            selected:
                            tab == widget.current,
                            badge:
                            tab == CustomerTab.cart
                                ? count
                                : 0,
                            onTap: () =>
                                widget.onSelect(tab),
                          ),
                        );
                      }),
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