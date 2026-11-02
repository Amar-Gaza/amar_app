import 'package:get/get.dart';

import '../../core/network/api_failure.dart';
import '../../data/models/cart/cart_item.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/catalog_service.dart';
import 'cart_controller.dart';

/// One product across details, options and quantity screens.
class ProductController extends GetxController {
  ProductController(this._service, this._cart, this.productId);

  static const int minQty = 1;

  final CatalogService _service;
  final CartController _cart;
  final int productId;

  final Rxn<Product> product = Rxn<Product>();
  final Rxn<Vendor> vendor = Rxn<Vendor>();
  final RxBool isLoading = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  final RxMap<String, List<String>> selections = <String, List<String>>{}.obs;
  final RxInt qty = minQty.obs;

  bool get hasOptions => product.value?.options.isNotEmpty ?? false;

  /// Upper bound from stock when the server shares it.
  int? get maxQty => product.value?.stock;

  bool get missingRequired =>
      product.value?.options.any(
        (o) => o.required && (selections[o.key]?.isEmpty ?? true),
      ) ??
      false;

  int get cartCount => _cart.count;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    if (isLoading.value) return;
    isLoading.value = true;
    failure.value = null;
    try {
      final loaded = await _service.product(productId);
      product.value = loaded;
      _selectDefaults(loaded);
      final vendorId = loaded.vendorId;
      if (vendorId != null) {
        try {
          vendor.value = await _service.vendor(vendorId);
        } on ApiFailure {
          // The vendor box is optional on this screen.
        }
      }
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  /// Required single options start on their first choice.
  void _selectDefaults(Product loaded) {
    for (final option in loaded.options) {
      if (option.required &&
          option.type == ProductOptionType.single &&
          option.choices.isNotEmpty) {
        selections[option.key] = [option.choices.first.key];
      }
    }
  }

  void toggle(ProductOption option, ProductChoice choice) {
    final current = [...?selections[option.key]];
    if (option.type == ProductOptionType.multi) {
      current.contains(choice.key)
          ? current.remove(choice.key)
          : current.add(choice.key);
      selections[option.key] = current;
    } else {
      selections[option.key] = [choice.key];
    }
  }

  bool isSelected(ProductOption option, ProductChoice choice) =>
      selections[option.key]?.contains(choice.key) ?? false;

  void increment() {
    final max = maxQty;
    if (max != null && qty.value >= max) return;
    qty.value++;
  }

  void decrement() {
    if (qty.value > minQty) qty.value--;
  }

  CartItem _item() => CartItem(
        product: product.value!,
        qty: qty.value,
        options: Map<String, List<String>>.from(selections),
      );

  AddToCartResult addToCart() => _cart.add(_item());

  void startServiceRequest() => _cart.service.value = _item();

  void replaceCart() => _cart.replaceWith(_item());
}
