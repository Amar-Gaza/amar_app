import 'package:get/get.dart';

import '../../data/models/cart/cart_item.dart';
import '../../data/models/masar/masar_models.dart';

enum AddToCartResult { added, otherVendor }

/// Catalog cart. One vendor per cart, because a quote is per vendor.
class CartController extends GetxController {
  final RxList<CartItem> items = <CartItem>[].obs;

  int get count => items.fold(0, (sum, item) => sum + item.qty);
  int? get vendorId => items.isEmpty ? null : items.first.product.vendorId;

  /// Returns [AddToCartResult.otherVendor] without changing the cart when
  /// the product belongs to another vendor; call [replaceWith] to confirm.
  AddToCartResult add(CartItem item) {
    final current = vendorId;
    if (current != null && item.product.vendorId != current) {
      return AddToCartResult.otherVendor;
    }
    final index = items.indexWhere((e) => e.key == item.key);
    if (index >= 0) {
      items[index] = items[index].copyWith(qty: items[index].qty + item.qty);
    } else {
      items.add(item);
    }
    return AddToCartResult.added;
  }

  void replaceWith(CartItem item) => items.assignAll([item]);

  void setQty(CartItem item, int qty) {
    final index = items.indexWhere((e) => e.key == item.key);
    if (index < 0) return;
    if (qty <= 0) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(qty: qty);
    }
  }

  void remove(CartItem item) => items.removeWhere((e) => e.key == item.key);

  void clear() => items.clear();

  int quantityOf(Product product) => items
      .where((e) => e.product.id == product.id)
      .fold(0, (sum, e) => sum + e.qty);
}
