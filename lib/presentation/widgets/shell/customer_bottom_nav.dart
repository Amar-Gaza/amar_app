import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/shell_controller.dart';
import '../../../l10n/app_localizations.dart';
import 'nav_item.dart';

/// Four fixed customer destinations.
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
    final items = <(CustomerTab, IconData, String)>[
      (CustomerTab.home, LucideIcons.house, l10n.navHome),
      (CustomerTab.orders, LucideIcons.fileText, l10n.navOrders),
      (CustomerTab.notifications, LucideIcons.bell, l10n.navNotifications),
      (CustomerTab.account, LucideIcons.user, l10n.navAccount),
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (final (tab, icon, label) in items)
              Expanded(
                child: NavItem(
                  icon: icon,
                  label: label,
                  selected: tab == current,
                  onTap: () => onSelect(tab),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
