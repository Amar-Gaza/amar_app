import 'package:get/get.dart';

import '../../core/network/api_failure.dart';
import '../../data/models/api/paged.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/catalog_service.dart';
import '../shared/paged_list_controller.dart';

enum VendorTab { products, hours, about }

/// Vendor header (GET /vendors/{id}) plus its products as a paged list.
class VendorDetailsController extends PagedListController<Product> {
  VendorDetailsController(this._service, this.vendorId);

  final CatalogService _service;
  final int vendorId;
  final Rxn<Vendor> vendor = Rxn<Vendor>();
  final Rx<VendorTab> tab = VendorTab.products.obs;
  final RxBool isVendorLoading = false.obs;
  final Rxn<ApiFailure> vendorFailure = Rxn<ApiFailure>();

  @override
  void onInit() {
    super.onInit();
    loadVendor();
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
    await Future.wait([loadVendor(), load()]);
  }

  @override
  Future<Paged<Product>> fetch(int page, int perPage) =>
      _service.products(vendorId: vendorId, page: page, perPage: perPage);
}
