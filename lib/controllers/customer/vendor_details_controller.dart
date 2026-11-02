import 'package:get/get.dart';

import '../../core/constants/api_query.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/api/paged.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/catalog_service.dart';
import '../shared/paged_list_controller.dart';

enum VendorTab { products, services, hours, about }

/// Vendor header (GET /vendors/{id}) plus its products or services as a
/// paged list. A vendor offering one kind only gets one list tab.
class VendorDetailsController extends PagedListController<Product> {
  VendorDetailsController(this._service, this.vendorId);

  final CatalogService _service;
  final int vendorId;
  final Rxn<Vendor> vendor = Rxn<Vendor>();
  final Rx<VendorTab> tab = VendorTab.products.obs;
  final RxBool isVendorLoading = false.obs;
  final RxBool hasProducts = false.obs;
  final RxBool hasServices = false.obs;
  final Rxn<ApiFailure> vendorFailure = Rxn<ApiFailure>();

  String _kind = ProductKinds.product;

  @override
  bool get loadOnInit => false;

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  /// List tabs reload for their kind; ignored while a page is loading so a
  /// late response can't land under the other tab.
  void selectTab(VendorTab value) {
    if (value == tab.value || isLoading.value) return;
    tab.value = value;
    final kind = switch (value) {
      VendorTab.products => ProductKinds.product,
      VendorTab.services => ProductKinds.service,
      _ => _kind,
    };
    if (kind == _kind) return;
    _kind = kind;
    items.clear();
    load();
  }

  Future<void> loadVendor() async {
    if (isVendorLoading.value) return;
    isVendorLoading.value = true;
    vendorFailure.value = null;
    try {
      vendor.value = await _service.vendor(vendorId);
    } on ApiFailure catch (e) {
      vendorFailure.value = e;
    } finally {
      isVendorLoading.value = false;
    }
  }

  Future<void> reload() async {
    await Future.wait([loadVendor(), _loadKinds()]);
    await load();
  }

  Future<void> _loadKinds() async {
    final found = await Future.wait([
      _offers(ProductKinds.product),
      _offers(ProductKinds.service),
    ]);
    hasProducts.value = found[0];
    hasServices.value = found[1];
    if (!found[0] && found[1] && tab.value == VendorTab.products) {
      tab.value = VendorTab.services;
      _kind = ProductKinds.service;
    }
  }

  Future<bool> _offers(String kind) async {
    try {
      final page = await _service.products(
        vendorId: vendorId,
        kind: kind,
        perPage: 1,
      );
      return page.total > 0;
    } on ApiFailure {
      return false;
    }
  }

  @override
  Future<Paged<Product>> fetch(int page, int perPage) => _service.products(
        vendorId: vendorId,
        kind: _kind,
        page: page,
        perPage: perPage,
      );
}
