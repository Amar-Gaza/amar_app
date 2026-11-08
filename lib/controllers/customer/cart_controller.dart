import 'dart:async';

import 'package:get/get.dart';

import '../../core/constants/storage_keys.dart';
import '../../core/storage/app_preferences.dart';
import '../../data/models/cart/cart_item.dart';
import '../../data/models/masar/masar_models.dart';

enum AddToCartResult {
  added,
  otherVendor,
}

/// Catalog cart.
/// One vendor per cart, because a quote is per vendor.
class CartController extends GetxController {
  CartController({
    AppPreferences? preferences,
  }) : _preferences = preferences {
    _customerId = preferences?.activeCustomerId;
    _restore();
  }

  final AppPreferences? _preferences;

  int? _customerId;

  final RxList<CartItem> items = <CartItem>[].obs;

  /// Service being requested.
  /// It checks out alone and never joins the cart.
  final Rxn<CartItem> service = Rxn<CartItem>();

  /// Switch synchronously so a different
  /// customer never sees this cart.
  void activateCustomer(int? customerId) {
    if (_customerId == customerId) return;

    _customerId = customerId;
    service.value = null;

    _restore();
  }

  void _restore() {
    final snapshot = _preferences?.customerState(
      StorageKeys.customerCart,
      customerId: _customerId,
    );

    final restored = <CartItem>[];
    final rawItems = snapshot?['items'];

    if (snapshot?['schema'] == 1 && rawItems is List) {
      for (final raw in rawItems) {
        try {
          final item = CartItem.fromJson(
            Map<String, dynamic>.from(raw as Map),
          );

          if (restored.isNotEmpty &&
              restored.first.product.vendorId != item.product.vendorId) {
            continue;
          }

          final index = restored.indexWhere(
            (other) => other.key == item.key,
          );

          if (index < 0) {
            restored.add(item);
          } else {
            restored[index] = restored[index].copyWith(
              qty: restored[index].qty + item.qty,
            );
          }
        } catch (_) {
          // A malformed line must not hide
          // the remaining saved products.
        }
      }
    }

    items.assignAll(restored);
  }

  void _persist() {
    final preferences = _preferences;

    if (preferences == null) return;

    unawaited(
      preferences.saveCustomerState(
        StorageKeys.customerCart,
        {
          'schema': 1,
          'items': items.map((item) => item.toJson()).toList(),
        },
        customerId: _customerId,
      ),
    );
  }

  List<CartItem> get checkoutItems {
    final pending = service.value;

    return pending == null ? items : [pending];
  }

  int? get checkoutVendorId => service.value?.product.vendorId ?? vendorId;

  void clearCheckout() {
    if (service.value == null) {
      clear();
    } else {
      service.value = null;
    }
  }

  int get count => items.fold(
        0,
        (sum, item) => sum + item.qty,
      );

  int? get vendorId => items.isEmpty ? null : items.first.product.vendorId;

  /// Returns otherVendor without changing the cart.
  /// Call replaceWith after confirmation.
  AddToCartResult add(CartItem item) {
    final current = vendorId;

    if (current != null && item.product.vendorId != current) {
      return AddToCartResult.otherVendor;
    }

    final index = items.indexWhere(
      (existing) => existing.key == item.key,
    );

    if (index >= 0) {
      items[index] = items[index].copyWith(
        qty: items[index].qty + item.qty,
      );
    } else {
      items.add(item);
    }

    _persist();

    return AddToCartResult.added;
  }

  void replaceWith(CartItem item) {
    items.assignAll([item]);
    _persist();
  }

  void setQty(CartItem item, int qty) {
    final index = items.indexWhere(
      (existing) => existing.key == item.key,
    );

    if (index < 0) return;

    if (qty <= 0) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(qty: qty);
    }

    _persist();
  }

  void remove(CartItem item) {
    items.removeWhere(
      (existing) => existing.key == item.key,
    );

    _persist();
  }

  void clear() {
    items.clear();
    _persist();
  }

  int quantityOf(Product product) =>
      items.where((item) => item.product.id == product.id).fold(
            0,
            (sum, item) => sum + item.qty,
          );
}
