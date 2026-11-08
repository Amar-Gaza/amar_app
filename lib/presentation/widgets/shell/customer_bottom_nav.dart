import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/cart_controller.dart';
import '../../../controllers/customer/shell_controller.dart';
import '../../../l10n/app_localizations.dart';
import 'curved_bottom_nav.dart';

/// Customer tabs on the shared floating bar, with the cart count badge.
class CustomerBottomNav extends StatelessWidget {
  const CustomerBottomNav({
    super.key,
    required this.current,
    required this.onSelect,
  });

  final CustomerTab current;
  final ValueChanged<CustomerTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cart = Get.find<CartController>();

    // Order matches [CustomerTab].
    final items = <(IconData, String)>[
      (LucideIcons.house, l10n.navHome),
      (LucideIcons.clipboardList, l10n.navOrders),
      (LucideIcons.shoppingCart, l10n.navCart),
      (LucideIcons.user, l10n.navAccount),
    ];

    return Obx(() {
      final count = cart.count;
      return CurvedBottomNav(
        items: items,
        currentIndex: current.index,
        onSelect: (i) => onSelect(CustomerTab.values[i]),
        badges: [
          for (final tab in CustomerTab.values)
            tab == CustomerTab.cart ? count : 0,
        ],
      );
    });
  }
}
