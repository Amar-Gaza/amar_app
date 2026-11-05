
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/constants/api_query.dart';
import '../../core/network/api_failure.dart';

import '../../data/models/catalog/picked_location.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/models/requests/address_request.dart';

import '../../data/services/customer/address_service.dart';
import '../../data/services/shared/device_location_service.dart';

class AddressFormController extends GetxController {
  AddressFormController(
      this._addresses,
      this._location, {
        this.existing,
        this.initial,
        this.useCurrentLocation = false,
      });

  final AddressService _addresses;
  final DeviceLocationService _location;

  final Address? existing;
  final PickedLocation? initial;
  final bool useCurrentLocation;

  final TextEditingController label =
  TextEditingController();

  final TextEditingController details =
  TextEditingController();

  final RxBool isDefault = false.obs;

  final RxnDouble lat = RxnDouble();
  final RxnDouble lng = RxnDouble();

  final RxBool isLocating = false.obs;
  final RxBool isSaving = false.obs;

  final Rxn<LocationIssue> locationIssue =
  Rxn<LocationIssue>();

  final RxBool addressUnavailable = false.obs;

  final Rxn<ApiFailure> failure =
  Rxn<ApiFailure>();

  final RxBool labelMissing = false.obs;
  final RxBool positionMissing = false.obs;

  int _positionRevision = 0;

  String? _automaticDetails;

  bool get hasPosition =>
      lat.value != null && lng.value != null;

  bool get isEditing => existing != null;

  PickedLocation? get selectedPoint {
    if (!hasPosition) return null;

    return PickedLocation(
      lat: lat.value!,
      lng: lng.value!,
    );
  }

  @override
  void onInit() {
    super.onInit();

    final address = existing;

    // Editing an existing address.
    if (address != null) {
      label.text = address.label ?? '';
      details.text = address.details ?? '';
      isDefault.value = address.isDefault;

      lat.value = address.lat;
      lng.value = address.lng;
      return;
    }

    // New address with coordinates from the map.
    if (initial != null && !useCurrentLocation) {
      lat.value = initial!.lat;
      lng.value = initial!.lng;
    }
  }

  @override
  void onReady() {
    super.onReady();

    if (isEditing) return;

    // Keep manually selected coordinates.
    if (initial != null && !useCurrentLocation) {
      setPosition(initial!);
    } else {
      // Obtain GPS only when no manual location
      // was supplied or explicitly requested.
      locate();
    }
  }

  Future<void> locate() async {
    if (isLocating.value) return;

    final revision = ++_positionRevision;

    isLocating.value = true;
    locationIssue.value = null;
    addressUnavailable.value = false;
    failure.value = null;

    try {
      final location =
      await _location.currentAddress();

      // Ignore GPS results if the user selected
      // another point while GPS was loading.
      if (revision != _positionRevision) return;

      lat.value = location.point.lat;
      lng.value = location.point.lng;

      positionMissing.value = false;

      _updateAutomaticDetails(location.label);
    } on LocationException catch (error) {
      if (revision != _positionRevision) return;

      locationIssue.value = error.issue;
    } on LocationAddressException {
      if (revision != _positionRevision) return;

      final point = _location.currentPoint.value;

      if (point != null) {
        lat.value = point.lat;
        lng.value = point.lng;
        positionMissing.value = false;
      }

      addressUnavailable.value = true;
    } finally {
      isLocating.value = false;
    }
  }

  Future<void> setPosition(
      PickedLocation point,
      ) async {
    // Invalidate any older GPS or geocoding request.
    final revision = ++_positionRevision;

    // Immediately apply the user's selected point.
    lat.value = point.lat;
    lng.value = point.lng;

    positionMissing.value = false;
    locationIssue.value = null;
    addressUnavailable.value = false;
    failure.value = null;

    _clearAutomaticDetails();

    try {
      final location =
      await _location.resolveAddress(point);

      if (revision != _positionRevision) return;

      _updateAutomaticDetails(location.label);
    } on LocationAddressException {
      if (revision != _positionRevision) return;

      // Coordinates remain valid even if
      // reverse geocoding cannot find a street.
      addressUnavailable.value = true;
    }
  }

  void _updateAutomaticDetails(String value) {
    if (details.text.trim().isEmpty ||
        details.text == _automaticDetails) {
      details.text = value;
      _automaticDetails = value;
    }
  }

  void _clearAutomaticDetails() {
    if (_automaticDetails != null &&
        details.text == _automaticDetails) {
      details.clear();
    }

    _automaticDetails = null;
  }

  Future<bool> openSettings() {
    return _location.openSettings();
  }

  Future<bool> openLocationSettings() {
    return _location.openLocationSettings();
  }

  Future<Address?> save() async {
    if (isSaving.value) return null;

    labelMissing.value = label.text.trim().isEmpty;
    positionMissing.value = !hasPosition;

    if (labelMissing.value ||
        positionMissing.value) {
      return null;
    }

    final point = selectedPoint!;

    isSaving.value = true;
    failure.value = null;

    try {
      // Send the selected map coordinates,
      // not the last GPS coordinates.
      final request = AddressRequest(
        label: label.text.trim(),
        lat: point.lat,
        lng: point.lng,
        details: details.text.trim().isEmpty
            ? null
            : details.text.trim(),
        isDefault: isDefault.value,
      );

      final address = existing;

      if (address != null) {
        return await _addresses.update(
          address.id,
          request,
        );
      }

      return await _addresses.create(request);
    } on ApiFailure catch (error) {
      failure.value = error;
      return null;
    } catch (_) {
      failure.value = const ApiFailure(
        code: ApiErrorCodes.serverError,
      );
      return null;
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    // Invalidate pending async results.
    _positionRevision++;

    label.dispose();
    details.dispose();

    super.onClose();
  }
}
