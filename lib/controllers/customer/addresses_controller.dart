import 'package:get/get.dart';

import '../../core/network/api_failure.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/address_service.dart';

/// Saved addresses management (account designs 03–06).
class AddressesController extends GetxController {
  AddressesController(this._service);

  final AddressService _service;
  final RxList<Address> items = <Address>[].obs;
  final RxBool isLoading = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();

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
      items.assignAll(await _service.list());
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> delete(Address address) async {
    try {
      await _service.delete(address.id);
      items.removeWhere((a) => a.id == address.id);
      return true;
    } on ApiFailure catch (e) {
      failure.value = e;
      return false;
    }
  }
}
