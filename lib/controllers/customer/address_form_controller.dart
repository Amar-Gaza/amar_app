import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/network/api_failure.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/models/requests/address_request.dart';
import '../../data/services/customer/address_service.dart';
import '../../data/services/shared/device_location_service.dart';

/// New or edited address: device position + label + details.
class AddressFormController extends GetxController {
  AddressFormController(this._addresses, this._location, {this.existing});

  final AddressService _addresses;
  final DeviceLocationService _location;

  /// Set when editing (PUT /addresses/{id}).
  final Address? existing;

  final TextEditingController label = TextEditingController();
  final TextEditingController details = TextEditingController();
  final RxBool isDefault = false.obs;
  final RxnDouble lat = RxnDouble();
  final RxnDouble lng = RxnDouble();
  final RxBool isLocating = false.obs;
  final Rxn<LocationIssue> locationIssue = Rxn<LocationIssue>();
  final RxBool isSaving = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  final RxBool labelMissing = false.obs;

  bool get hasPosition => lat.value != null && lng.value != null;

  bool get isEditing => existing != null;

  @override
  void onInit() {
    super.onInit();
    final address = existing;
    if (address == null) return;
    label.text = address.label ?? '';
    details.text = address.details ?? '';
    isDefault.value = address.isDefault;
    lat.value = address.lat;
    lng.value = address.lng;
  }

  @override
  void onReady() {
    super.onReady();
    if (!isEditing) locate();
  }

  Future<void> locate() async {
    if (isLocating.value) return;
    isLocating.value = true;
    locationIssue.value = null;
    try {
      final position = await _location.current();
      lat.value = position.latitude;
      lng.value = position.longitude;
    } on LocationException catch (e) {
      locationIssue.value = e.issue;
    } finally {
      isLocating.value = false;
    }
  }

  Future<bool> openSettings() => _location.openSettings();

  /// Returns the created address, or null when validation or the server
  /// rejected it.
  Future<Address?> save() async {
    labelMissing.value = label.text.trim().isEmpty;
    if (labelMissing.value || !hasPosition || isSaving.value) return null;
    isSaving.value = true;
    failure.value = null;
    try {
      final request = AddressRequest(
        label: label.text.trim(),
        lat: lat.value!,
        lng: lng.value!,
        details: details.text.trim().isEmpty ? null : details.text.trim(),
        isDefault: isDefault.value,
      );
      final address = existing;
      return address == null
          ? await _addresses.create(request)
          : await _addresses.update(address.id, request);
    } on ApiFailure catch (e) {
      failure.value = e;
      return null;
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    label.dispose();
    details.dispose();
    super.onClose();
  }
}
