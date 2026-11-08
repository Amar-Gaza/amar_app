import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/constants/api_query.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/catalog/picked_location.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/models/requests/address_request.dart';
import '../../data/services/customer/address_service.dart';
import '../../data/services/shared/device_location_service.dart';

/// Create or edit a customer address.
///
/// Supports:
/// - Current GPS location.
/// - Manually selected map location.
/// - Editing existing addresses.
/// - Saving to Masar API.
/// - Validation for missing label and position.
class AddressFormController extends GetxController {
  AddressFormController(
    this._addresses,
    this._location, {
    this.existing,
    this.initialPoint,
  });

  final AddressService _addresses;
  final DeviceLocationService _location;

  /// Existing address when editing.
  final Address? existing;

  /// Coordinates selected on the map.
  final PickedLocation? initialPoint;

  // Form fields
  final TextEditingController label = TextEditingController();

  final TextEditingController details = TextEditingController();

  // Address settings
  final RxBool isDefault = false.obs;

  // Coordinates
  final RxnDouble lat = RxnDouble();
  final RxnDouble lng = RxnDouble();

  // GPS state
  final RxBool isLocating = false.obs;

  final Rxn<LocationIssue> locationIssue = Rxn<LocationIssue>();

  final RxBool addressUnavailable = false.obs;

  // Saving state
  final RxBool isSaving = false.obs;

  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();

  // Form validation
  final RxBool labelMissing = false.obs;

  // FIX V7:
  // Required by address_form_screen.dart.
  final RxBool positionMissing = false.obs;

  String? _locationDetails;

  Worker? _locationWorker;

  bool get hasPosition => lat.value != null && lng.value != null;

  bool get isEditing => existing != null;

  @override
  void onInit() {
    super.onInit();

    _locationWorker = ever<ResolvedLocation?>(
      _location.resolvedLocation,
      (location) {
        if (location != null) {
          _updateLocationDetails(location.label);
        }
      },
    );

    final address = existing;

    if (address == null) {
      return;
    }

    label.text = address.label ?? '';
    details.text = address.details ?? '';

    isDefault.value = address.isDefault;

    lat.value = address.lat;
    lng.value = address.lng;

    positionMissing.value = false;
  }

  @override
  void onReady() {
    super.onReady();

    if (isEditing) {
      return;
    }

    final point = initialPoint;

    if (point != null) {
      // Use the location selected on the map.
      // Do not replace it with GPS.
      unawaited(setPosition(point));
    } else {
      // No selected map location:
      // use the current GPS location.
      unawaited(locate());
    }
  }

  /// Get current device location.
  Future<void> locate() async {
    if (isLocating.value) {
      return;
    }

    isLocating.value = true;

    locationIssue.value = null;
    addressUnavailable.value = false;

    try {
      final location = await _location.currentAddress();

      lat.value = location.point.lat;
      lng.value = location.point.lng;

      positionMissing.value = false;

      _updateLocationDetails(location.label);
    } on LocationException catch (error) {
      locationIssue.value = error.issue;

      positionMissing.value = !hasPosition;
    } on LocationAddressException {
      addressUnavailable.value = true;

      final point = _location.currentPoint.value;

      if (point != null) {
        lat.value = point.lat;
        lng.value = point.lng;

        positionMissing.value = false;
      } else {
        positionMissing.value = !hasPosition;
      }

      _clearLocationDetailsIfAutomatic();
    } finally {
      isLocating.value = false;
    }
  }

  /// Update position using the exact point
  /// selected by the user on Google Maps.
  Future<void> setPosition(
    PickedLocation point,
  ) async {
    if (!point.lat.isFinite ||
        !point.lng.isFinite ||
        point.lat < -90 ||
        point.lat > 90 ||
        point.lng < -180 ||
        point.lng > 180) {
      positionMissing.value = true;
      return;
    }

    // Preserve the manually selected coordinates.
    lat.value = point.lat;
    lng.value = point.lng;

    positionMissing.value = false;

    locationIssue.value = null;
    addressUnavailable.value = false;

    try {
      final location = await _location.resolveAddress(point);

      _updateLocationDetails(location.label);
    } on LocationAddressException {
      // Keep coordinates even when
      // reverse geocoding is unavailable.
      addressUnavailable.value = true;

      _clearLocationDetailsIfAutomatic();
    }
  }

  /// Open app permissions settings.
  Future<bool> openSettings() => _location.openSettings();

  /// Open device location settings.
  Future<bool> openLocationSettings() => _location.openLocationSettings();

  /// Update address details without overwriting
  /// manually written customer text.
  void _updateLocationDetails(
    String value,
  ) {
    if (details.text.trim().isEmpty || details.text == _locationDetails) {
      details.text = value;

      _locationDetails = value;
    }
  }

  /// Clear an automatically populated address
  /// when reverse geocoding is unavailable.
  void _clearLocationDetailsIfAutomatic() {
    if (_locationDetails != null && details.text == _locationDetails) {
      details.clear();
    }

    _locationDetails = null;
  }

  /// Validate the address form.
  bool validate() {
    labelMissing.value = label.text.trim().isEmpty;

    positionMissing.value = !hasPosition;

    if (hasPosition) {
      final latitude = lat.value!;
      final longitude = lng.value!;

      if (!latitude.isFinite ||
          !longitude.isFinite ||
          latitude < -90 ||
          latitude > 90 ||
          longitude < -180 ||
          longitude > 180) {
        positionMissing.value = true;
      }
    }

    return !labelMissing.value && !positionMissing.value;
  }

  /// Save a new address or update an existing one.
  ///
  /// Returns:
  /// Address: successful server save.
  /// null: validation or API failure.
  Future<Address?> save() async {
    if (isSaving.value) {
      return null;
    }

    if (!validate()) {
      return null;
    }

    isSaving.value = true;
    failure.value = null;

    try {
      final cleanLabel = label.text.trim();
      final cleanDetails = details.text.trim();

      final request = AddressRequest(
        label: cleanLabel,
        lat: lat.value!,
        lng: lng.value!,
        details: cleanDetails.isEmpty ? null : cleanDetails,
        isDefault: isDefault.value,
      );

      final address = existing;

      final Address saved;

      if (address == null) {
        // POST /v1/addresses
        saved = await _addresses.create(request);
      } else {
        // Update the existing address.
        saved = await _addresses.update(
          address.id,
          request,
        );
      }

      labelMissing.value = false;
      positionMissing.value = false;

      return saved;
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
    _locationWorker?.dispose();

    label.dispose();
    details.dispose();

    super.onClose();
  }
}
