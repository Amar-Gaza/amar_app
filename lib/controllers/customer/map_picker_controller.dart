import 'package:get/get.dart';

import '../../core/constants/app_defaults.dart';
import '../../data/models/catalog/picked_location.dart';
import '../../data/services/shared/device_location_service.dart';

/// Tracks the point under the map's center pin.
class MapPickerController extends GetxController {
  MapPickerController(this._location, this.initial);

  final DeviceLocationService _location;
  final PickedLocation? initial;

  late PickedLocation point = initial ??
      const PickedLocation(
        lat: AppDefaults.mapDefaultLat,
        lng: AppDefaults.mapDefaultLng,
      );

  /// Set when the device position arrives; the screen moves the camera to it.
  final Rxn<PickedLocation> located = Rxn<PickedLocation>();
  final RxBool isLocating = false.obs;
  final Rxn<LocationIssue> issue = Rxn<LocationIssue>();

  @override
  void onReady() {
    super.onReady();
    if (initial == null) locate();
  }

  void move(double lat, double lng) =>
      point = PickedLocation(lat: lat, lng: lng);

  Future<void> locate() async {
    if (isLocating.value) return;
    isLocating.value = true;
    issue.value = null;
    try {
      final position = await _location.current();
      located.value = PickedLocation(
        lat: position.latitude,
        lng: position.longitude,
      );
    } on LocationException catch (e) {
      issue.value = e.issue;
    } finally {
      isLocating.value = false;
    }
  }

  Future<bool> openSettings() => _location.openSettings();
}
