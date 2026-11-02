import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/customer/shell_controller.dart';
import '../../../../controllers/shared/connectivity_controller.dart';
import '../../../widgets/common/offline_banner.dart';
import '../../../widgets/shell/customer_bottom_nav.dart';
import '../account/account_tab.dart';
import '../cart/cart_tab.dart';
import '../home/home_tab.dart';
import '../orders/orders_tab.dart';

/// Customer app frame: offline strip, the active tab and the bottom nav.
class CustomerShellScreen extends GetView<ShellController> {
  const CustomerShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivity = Get.find<ConnectivityController>();
    return Obx(
      () => Scaffold(
        body: Column(
          children: [
            if (connectivity.isOffline.value)
              const SafeArea(bottom: false, child: OfflineBanner()),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: connectivity.isOffline.value,
                child: IndexedStack(
                  index: controller.tab.value.index,
                  children: [
                    const HomeTab(),
                    const OrdersTab(),
                    if (controller.tab.value == CustomerTab.cart)
                      const CartTab()
                    else
                      const SizedBox.shrink(),
                    const AccountTab(),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomerBottomNav(
          current: controller.tab.value,
          onSelect: controller.select,
        ),
      ),
    );
  }
}
