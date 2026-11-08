import 'dart:async';

import 'package:get/get.dart';

import '../../core/constants/app_defaults.dart';
import '../../data/models/catalog/picked_location.dart';
import '../../data/services/shared/device_location_service.dart';

class MapPickerController extends GetxController {
  MapPickerController(
    this._location,
    this.initial, {
    this.autoLocate = true,
  });

  final DeviceLocationService _location;
  final PickedLocation? initial;
  final bool autoLocate;

  static bool _isInGaza(PickedLocation? point) =>
      point != null &&
      point.lat >= 31.20 &&
      point.lat <= 31.63 &&
      point.lng >= 34.15 &&
      point.lng <= 34.62;

  late final PickedLocation _start = initial ??
      (_isInGaza(_location.currentPoint.value)
          ? _location.currentPoint.value!
          : const PickedLocation(
              lat: AppDefaults.mapDefaultLat,
              lng: AppDefaults.mapDefaultLng,
            ));

  late final Rx<PickedLocation> _point = _start.obs;

  late final RxBool hasSelection =
      (initial != null || _isInGaza(_location.currentPoint.value)).obs;

  PickedLocation get point => _point.value;

  bool get canConfirm => hasSelection.value && !isDragging.value;

  final Rxn<PickedLocation> located = Rxn<PickedLocation>();

  final Rxn<ResolvedLocation> address = Rxn<ResolvedLocation>();

  final Rxn<LocationIssue> issue = Rxn<LocationIssue>();

  final RxBool isLocating = false.obs;
  final RxBool isResolving = false.obs;
  final RxBool addressUnavailable = false.obs;
  final RxBool isDragging = false.obs;

  int _selectionVersion = 0;
  int _addressVersion = 0;

  @override
  void onReady() {
    super.onReady();

    if (initial != null || hasSelection.value) {
      unawaited(_resolveAddress(point));
    } else if (autoLocate) {
      unawaited(locate());
    }
  }

  void beginManualSelection() {
    _selectionVersion++;
    _addressVersion++;

    isDragging.value = true;
    issue.value = null;
  }

  void setPoint(PickedLocation selected) {
    _selectionVersion++;

    _point.value = selected;
    hasSelection.value = true;
    isDragging.value = false;
    issue.value = null;

    unawaited(_resolveAddress(selected));
  }

  Future<void> _resolveAddress(
    PickedLocation selected,
  ) async {
    final request = ++_addressVersion;

    isResolving.value = true;
    addressUnavailable.value = false;
    address.value = null;

    try {
      final result = await _location.resolveAddress(selected);

      if (request == _addressVersion) {
        address.value = result;
      }
    } on LocationAddressException {
      if (request == _addressVersion) {
        addressUnavailable.value = true;
      }
    } finally {
      if (request == _addressVersion) {
        isResolving.value = false;
      }
    }
  }

  Future<void> locate() async {
    if (isLocating.value) return;

    final request = ++_selectionVersion;

    isLocating.value = true;
    issue.value = null;

    try {
      final position = await _location.current();

      if (request != _selectionVersion) return;

      final selected = PickedLocation(
        lat: position.latitude,
        lng: position.longitude,
      );

      _point.value = selected;
      hasSelection.value = true;
      isDragging.value = false;

      unawaited(_resolveAddress(selected));

      located.value = selected;
    } on LocationException catch (error) {
      if (request == _selectionVersion) {
        issue.value = error.issue;
      }
    } finally {
      isLocating.value = false;
    }
  }

  Future<bool> openSettings() => _location.openSettings();

  Future<bool> openLocationSettings() => _location.openLocationSettings();

  @override
  void onClose() {
    _selectionVersion++;
    _addressVersion++;
    super.onClose();
  }
}
