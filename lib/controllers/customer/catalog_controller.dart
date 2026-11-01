import 'package:get/get.dart';

import '../../core/constants/app_defaults.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/masar/masar_models.dart';
import '../../core/constants/api_query.dart';
import '../../data/services/customer/catalog_service.dart';
import '../../data/services/customer/order_service.dart';

class CatalogController extends GetxController {
  CatalogController(this._service, this._orders);

  final CatalogService _service;
  final OrderService _orders;

  final RxList<Category> categories = <Category>[].obs;
  final RxList<Vendor> vendors = <Vendor>[].obs;
  final RxList<Product> products = <Product>[].obs;
  final Rxn<OrderSummary> activeOrder = Rxn<OrderSummary>();
  final RxBool isLoading = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();

  bool get isEmpty => categories.isEmpty && vendors.isEmpty && products.isEmpty;

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
      final results = await Future.wait<List<Object>>([
        _service.categories(),
        _optional(() async => (await _service.vendors(
              perPage: AppDefaults.homeStripLimit,
            ))
                .items),
        _optional(() async => (await _service.products(
              perPage: AppDefaults.homeStripLimit,
            ))
                .items),
        _optional(() async => (await _orders.list(
              scope: OrderScope.active,
              perPage: AppDefaults.activeOrderPreview,
            ))
                .items),
      ]);
      categories.assignAll(results[0].cast<Category>());
      activeOrder.value = results[3].cast<OrderSummary>().firstOrNull;
      vendors.assignAll(results[1].cast<Vendor>());
      products.assignAll(results[2].cast<Product>());
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  /// Vendors, products and the active order are secondary on home: a module the project has
  /// disabled hides its section instead of failing the whole screen.
  Future<List<T>> _optional<T>(Future<List<T>> Function() request) async {
    try {
      return await request();
    } on ApiFailure catch (e) {
      if (e.isConnectivity) rethrow;
      return <T>[];
    }
  }
}
