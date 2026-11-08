import 'dart:async';

import 'package:get/get.dart';

import '../../core/constants/api_query.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/catalog/category_group.dart';
import '../../data/models/catalog/provider_entry.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/address_service.dart';
import '../../data/services/customer/catalog_service.dart';
import '../../data/services/customer/order_service.dart';
import '../../data/services/shared/device_location_service.dart';

/// Home data: unified categories, products and the two provider sections.
class CatalogController extends GetxController {
  CatalogController(
    this._service,
    this._orders,
    this._addresses,
    this._location,
  );

  final CatalogService _service;
  final OrderService _orders;
  final AddressService _addresses;
  final DeviceLocationService _location;

  final RxList<CategoryGroup> categories = <CategoryGroup>[].obs;
  final RxList<Product> products = <Product>[].obs;
  final RxList<ProviderEntry> stores = <ProviderEntry>[].obs;
  final RxList<ProviderEntry> companies = <ProviderEntry>[].obs;
  final Rxn<OrderSummary> activeOrder = Rxn<OrderSummary>();
  final Rxn<Address> address = Rxn<Address>();
  final RxBool isLoading = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();

  bool get isEmpty =>
      categories.isEmpty &&
      products.isEmpty &&
      stores.isEmpty &&
      companies.isEmpty;

  List<ProviderEntry> providers(String kind) =>
      kind == ProductKinds.service ? companies : stores;

  @override
  void onReady() {
    super.onReady();
    // HomeTab first finds this controller from inside Obx.build.
    // Defer reactive updates until the first frame has completed.
    unawaited(load());
    unawaited(loadAddress());
  }

  /// The default address, or the first one, for the home location line.
  Future<void> loadAddress() async {
    try {
      final saved = await _addresses.list();

      address.value =
          saved.firstWhereOrNull((a) => a.isDefault) ?? saved.firstOrNull;
    } on ApiFailure {
      // The line keeps its prompt; nothing else depends on it.
    }
  }

  Future<void> load() async {
    unawaited(_location.refreshCurrentAddress());

    if (isLoading.value) return;

    isLoading.value = true;
    failure.value = null;

    try {
      final results = await Future.wait<List<Object>>([
        _service.categories(),
        _optional(
          () async => (await _service.vendors(
            perPage: AppDefaults.catalogPageMax,
          ))
              .items,
        ),
        _optional(() => _items(ProductKinds.product)),
        _optional(() => _items(ProductKinds.service)),
        _optional(
          () async => (await _orders.list(
            scope: OrderScope.active,
            perPage: AppDefaults.activeOrderPreview,
          ))
              .items,
        ),
      ]);

      final vendors = results[1].cast<Vendor>();
      final productItems = results[2].cast<Product>();
      final serviceItems = results[3].cast<Product>();

      categories.assignAll(
        CategoryGroup.merge(results[0].cast<Category>()),
      );

      products.assignAll(
        productItems.take(AppDefaults.homeStripLimit),
      );

      stores.assignAll(
        ProviderEntry.build(vendors, productItems),
      );

      companies.assignAll(
        ProviderEntry.build(vendors, serviceItems),
      );

      activeOrder.value = results[4].cast<OrderSummary>().firstOrNull;
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Product>> _items(String kind) async => (await _service.products(
        kind: kind,
        perPage: AppDefaults.catalogPageMax,
      ))
          .items;

  /// Everything but categories is secondary on home: a module the project has
  /// disabled hides its section instead of failing the whole screen.
  Future<List<T>> _optional<T>(
    Future<List<T>> Function() request,
  ) async {
    try {
      return await request();
    } on ApiFailure catch (e) {
      if (e.isConnectivity) rethrow;
      return <T>[];
    }
  }
}
