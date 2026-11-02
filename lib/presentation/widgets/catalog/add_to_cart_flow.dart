import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/routes/route_args.dart';
import '../../../core/constants/api_query.dart';
import '../../../controllers/customer/cart_controller.dart';
import '../../../controllers/customer/product_controller.dart';
import '../../../data/models/cart/cart_item.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/confirmation_dialog.dart';

/// UI side of adding to the cart: vendor conflict and confirmation.
abstract final class AddToCartFlow {
  /// Quick add from a grid. Services and products with options open their
  /// page, because a service is requested there and never joins the cart.
  static Future<void> quickAdd(BuildContext context, Product product) async {
    if (product.options.isNotEmpty || product.kind == ProductKinds.service) {
      await Get.toNamed<void>(
        AppRoutes.product,
        arguments: ProductArgs(product.id),
      );
      return;
    }
    final cart = Get.find<CartController>();
    final item = CartItem(product: product, qty: 1);
    if (cart.add(item) == AddToCartResult.otherVendor) {
      final replace = await _confirmReplace(context);
      if (!replace) return;
      cart.replaceWith(item);
    }
    if (context.mounted) _added(context);
  }

  /// Adds the configured product; returns whether it was added.
  static Future<bool> fromProduct(
    BuildContext context,
    ProductController controller,
  ) async {
    if (controller.addToCart() == AddToCartResult.otherVendor) {
      final replace = await _confirmReplace(context);
      if (!replace) return false;
      controller.replaceCart();
    }
    if (context.mounted) _added(context);
    return true;
  }

  static Future<bool> _confirmReplace(BuildContext context) =>
      ConfirmationDialog.show(
        context,
        AppLocalizations.of(context).cartOtherVendorMessage,
      );

  static void _added(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).cartAdded)),
      );
  }
}
