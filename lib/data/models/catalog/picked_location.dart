/// A coordinate chosen on the map or read from the device.
class PickedLocation {
  const PickedLocation({required this.lat, required this.lng});

  final double lat;
  final double lng;
}
