import 'dart:async';

import 'package:get/get.dart';

import '../../core/constants/app_defaults.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/requests/location_request.dart';
import '../../data/services/driver/driver_location_service.dart';
import '../../data/services/shared/device_location_service.dart'
    show DeviceLocationService, LocationException, LocationIssue;
import 'driver_session_controller.dart';

enum LocationState { idle, sending, ok, permission, unavailable, failed }

/// Sends the driver position while online; buffers fixes taken offline
/// and resends them in one batch (designs 06, 07, 23–25).
class DriverLocationController extends GetxController {
  DriverLocationController(this._device, this._service, this._session);

  final DeviceLocationService _device;
  final DriverLocationService _service;
  final DriverSessionController _session;

  final Rx<LocationState> state = LocationState.idle.obs;
  final Rxn<LocationIssue> issue = Rxn<LocationIssue>();
  final Rxn<DateTime> lastSent = Rxn<DateTime>();
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  final List<LocationPoint> _buffer = [];
  Timer? _timer;

  Duration get _interval {
    final min = _session.config.value?.driver?.locationMinIntervalSeconds ?? 0;
    final seconds = AppDefaults.driverLocationSeconds > min
        ? AppDefaults.driverLocationSeconds
        : min;
    return Duration(seconds: seconds);
  }

  bool get isRunning => _timer != null;

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(_interval, (_) => sendNow());
    sendNow();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    state.value = LocationState.idle;
  }

  /// One fix now. Returns whether the server stored it.
  Future<bool> sendNow() async {
    state.value = LocationState.sending;
    issue.value = null;
    LocationPoint point;
    try {
      final position = await _device.current();
      point = LocationPoint(
        lat: position.latitude,
        lng: position.longitude,
        accuracy: position.accuracy.round(),
        speed: position.speed < 0 ? null : position.speed,
        heading: position.heading < 0 ? null : position.heading.round(),
        recordedAt: DateTime.now(),
      );
    } on LocationException catch (e) {
      issue.value = e.issue;
      state.value = e.issue == LocationIssue.serviceDisabled
          ? LocationState.unavailable
          : LocationState.permission;
      return false;
    }
    try {
      await _service.send(
        LocationRequest(current: point, buffered: List.of(_buffer)),
      );
      _buffer.clear();
      lastSent.value = DateTime.now();
      failure.value = null;
      state.value = LocationState.ok;
      return true;
    } on ApiFailure catch (e) {
      if (_buffer.length < AppDefaults.driverLocationBuffer) _buffer.add(point);
      failure.value = e;
      state.value = LocationState.failed;
      return false;
    }
  }

  Future<bool> openSettings() => _device.openSettings();

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
