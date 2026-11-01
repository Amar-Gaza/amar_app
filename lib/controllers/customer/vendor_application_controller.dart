import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/network/api_failure.dart';
import '../../core/utils/validators.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/models/requests/vendor_application_request.dart';
import '../../data/services/customer/catalog_service.dart';
import '../../data/services/shared/device_location_service.dart';

/// "Become a store" form and its result (account designs 11, 12).
class VendorApplicationController extends GetxController {
  VendorApplicationController(this._catalog, this._location);

  final CatalogService _catalog;
  final DeviceLocationService _location;

  final TextEditingController business = TextEditingController();
  final TextEditingController contact = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController note = TextEditingController();
  final RxnString category = RxnString();
  final RxBool includeLocation = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool showErrors = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  final Rxn<VendorApplication> result = Rxn<VendorApplication>();

  bool get businessMissing => business.text.trim().isEmpty;
  bool get contactMissing => contact.text.trim().isEmpty;
  bool get phoneInvalid => Validators.phone(phone.text) != null;

  Future<void> submit() async {
    showErrors.value = true;
    if (businessMissing || contactMissing || phoneInvalid) return;
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    failure.value = null;
    try {
      double? lat;
      double? lng;
      if (includeLocation.value) {
        try {
          final position = await _location.current();
          lat = position.latitude;
          lng = position.longitude;
        } on LocationException {
          // Location is optional for an application.
        }
      }
      result.value = await _catalog.applyAsVendor(
        VendorApplicationRequest(
          businessName: business.text.trim(),
          contactName: contact.text.trim(),
          phone: Validators.normalizePhone(phone.text),
          category: category.value,
          lat: lat,
          lng: lng,
          note: note.text.trim().isEmpty ? null : note.text.trim(),
        ),
      );
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    business.dispose();
    contact.dispose();
    phone.dispose();
    note.dispose();
    super.onClose();
  }
}
