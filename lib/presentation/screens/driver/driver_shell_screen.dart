import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/driver/driver_home_controller.dart';
import '../../../controllers/shared/connectivity_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/common/offline_banner.dart';
import '../../widgets/shell/curved_bottom_nav.dart';
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
    // Order matches [DriverTab].
    final items = <(IconData, String)>[
      (LucideIcons.house, l10n.navHome),
      (LucideIcons.clipboardList, l10n.driverNavOrders),
      (LucideIcons.wallet, l10n.driverNavWallet),
      (LucideIcons.user, l10n.navAccount),
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
        bottomNavigationBar: CurvedBottomNav(
          items: items,
          currentIndex: controller.tab.value.index,
          onSelect: (i) => controller.tab.value = DriverTab.values[i],
        ),
      ),
    );
  }
}
