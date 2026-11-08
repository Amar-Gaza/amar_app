import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../app/routes/route_args.dart';
import '../../data/models/ai/ai_intent.dart';
import 'shell_controller.dart';

class AiActionExecutor {
  void run(AiGatewayReply result) {
    if (result.action == 'show_cart') {
      _openTab(CustomerTab.cart);
      return;
    }

    if (result.action == 'open_home') {
      _openTab(CustomerTab.home);
      return;
    }

    if (result.action == 'open_result' && result.navigate != null) {
      openItem(result.navigate!);
      return;
    }

    if (result.action == 'search_catalog' &&
        result.openScreen &&
        result.query.isNotEmpty) {
      Get.toNamed<void>(
        AppRoutes.search,
        arguments: AiSearchArgs(
          query: result.query,
          kind: result.kind == 'any' ? null : result.kind,
        ),
      );
    }
  }

  void _openTab(CustomerTab tab) {
    if (Get.isRegistered<ShellController>()) {
      Get.back<void>();

      Get.find<ShellController>().select(tab);
    } else {
      Get.offAllNamed<void>(AppRoutes.home);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.isRegistered<ShellController>()) {
          Get.find<ShellController>().select(tab);
        }
      });
    }
  }

  void openItem(AiCatalogItem item) {
    switch (item.type) {
      case 'vendor':
        Get.toNamed<void>(
          AppRoutes.vendor,
          arguments: item.id,
        );
        return;

      case 'product':
      case 'service':
        Get.toNamed<void>(
          AppRoutes.product,
          arguments: ProductArgs(item.id),
        );
        return;

      case 'category':
        Get.toNamed<void>(
          AppRoutes.products,
          arguments: ProductsArgs(
            categoryIds: [item.id],
            title: item.name,
          ),
        );
        return;
    }
  }
}
