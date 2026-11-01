import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/driver/driver_home_controller.dart';
import '../../../controllers/shared/connectivity_controller.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/common/offline_banner.dart';
import '../../widgets/shell/nav_item.dart';
import 'driver_account_tab.dart';
import 'driver_home_tab.dart';
import 'driver_orders_tab.dart';
import 'driver_wallet_tab.dart';

/// Driver app frame with its own four destinations.
class DriverShellScreen extends GetView<DriverHomeController> {
  const DriverShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final connectivity = Get.find<ConnectivityController>();
    final items = <(DriverTab, IconData, String)>[
      (DriverTab.home, LucideIcons.house, l10n.navHome),
      (DriverTab.orders, LucideIcons.fileText, l10n.driverNavOrders),
      (DriverTab.wallet, LucideIcons.wallet, l10n.driverNavWallet),
      (DriverTab.account, LucideIcons.user, l10n.navAccount),
    ];
    return Obx(
      () => Scaffold(
        body: Column(
          children: [
            if (connectivity.isOffline.value)
              const SafeArea(bottom: false, child: OfflineBanner()),
            Expanded(
              child: IndexedStack(
                index: controller.tab.value.index,
                children: const [
                  DriverHomeTab(),
                  DriverOrdersTab(),
                  DriverWalletTab(),
                  DriverAccountTab(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            color: context.scheme.surface,
            border: Border(top: BorderSide(color: context.appColors.border)),
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
                      selected: controller.tab.value == tab,
                      onTap: () => controller.tab.value = tab,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
