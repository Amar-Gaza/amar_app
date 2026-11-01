import 'package:geolocator/geolocator.dart';

enum LocationIssue { serviceDisabled, denied, deniedForever }

class LocationException implements Exception {
  const LocationException(this.issue);

  final LocationIssue issue;
}

/// Current device position with the permission dance in one place.
class DeviceLocationService {
  Future<Position> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(LocationIssue.serviceDisabled);
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(LocationIssue.deniedForever);
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException(LocationIssue.denied);
    }
    return Geolocator.getCurrentPosition();
  }

  Future<bool> openSettings() => Geolocator.openAppSettings();
}
