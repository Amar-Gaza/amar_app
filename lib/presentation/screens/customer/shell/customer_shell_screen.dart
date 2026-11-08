import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/localization/ai_labels.dart';
import '../../../../controllers/customer/shell_controller.dart';
import '../../../../controllers/shared/connectivity_controller.dart';
import '../../../widgets/common/offline_banner.dart';
import '../../../widgets/shell/customer_bottom_nav.dart';
import '../account/account_tab.dart';
import '../cart/cart_tab.dart';
import '../home/home_tab.dart';
import '../orders/orders_tab.dart';

class CustomerShellScreen extends GetView<ShellController> {
  const CustomerShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivity = Get.find<ConnectivityController>();

    return Obx(
      () => Scaffold(
        // Content scrolls behind the floating nav bar.
        extendBody: true,
        body: Column(
          children: [
            if (connectivity.isOffline.value)
              const SafeArea(
                bottom: false,
                child: OfflineBanner(),
              ),
            Expanded(
              // Read the body's MediaQuery (inside the Scaffold) so the tabs
              // keep the bottom padding that extendBody adds for the nav bar.
              child: Builder(
                builder: (bodyContext) => MediaQuery.removePadding(
                  context: bodyContext,
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
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.small(
          heroTag: 'amar_ai_assistant',
          tooltip: AiLabels(context).title,
          onPressed: () => Get.toNamed<void>(
            AppRoutes.aiAssistant,
          ),
          child: const Icon(
            Icons.smart_toy_outlined,
          ),
        ),
        bottomNavigationBar: CustomerBottomNav(
          current: controller.tab.value,
          onSelect: controller.select,
        ),
      ),
    );
  }
}
