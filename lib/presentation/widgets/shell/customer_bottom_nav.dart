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

/// Four tabs on a notched bar; a floating bubble marks the active one.
class CustomerBottomNav extends StatelessWidget {
  const CustomerBottomNav({
    super.key,
    required this.current,
    required this.onSelect,
  });

  static const double _shadowAlpha = 0.11;

  final CustomerTab current;
  final ValueChanged<CustomerTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final cart = Get.find<CartController>();
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final items = <(CustomerTab, IconData, String)>[
      (CustomerTab.home, LucideIcons.house, l10n.navHome),
      (CustomerTab.orders, LucideIcons.clipboardList, l10n.navOrders),
      (CustomerTab.cart, LucideIcons.shoppingCart, l10n.navCart),
      (CustomerTab.account, LucideIcons.user, l10n.navAccount),
    ];
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return SizedBox(
      height: AppSizes.navHeight + bottomInset,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final width = constraints.maxWidth;
          final tabWidth = width / items.length;
          final slot = current.index + 0.5;
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
                  child: Container(
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
                        Icon(
                          items[current.index].$2,
                          size: AppSizes.iconMd,
                          color: colors.onBrand,
                        ),
                        if (current == CustomerTab.cart)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Obx(
                              () => cart.count > 0
                                  ? NavBadge(count: cart.count)
                                  : const SizedBox.shrink(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Row(
                children: [
                  for (final (tab, icon, label) in items)
                    Expanded(
                      child: Obx(() {
                        final count = cart.count;
                        return NavItem(
                          icon: icon,
                          label: label,
                          selected: tab == current,
                          badge: tab == CustomerTab.cart ? count : 0,
                          onTap: () => onSelect(tab),
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
