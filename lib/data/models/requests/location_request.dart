/// One GPS fix sent by the driver app.
class LocationPoint {
  const LocationPoint({
    required this.lat,
    required this.lng,
    this.accuracy,
    this.speed,
    this.heading,
    this.recordedAt,
  });

  final double lat;
  final double lng;
  final int? accuracy;
  final double? speed;
  final int? heading;
  final DateTime? recordedAt;

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        if (accuracy != null) 'accuracy': accuracy,
        if (speed != null) 'speed': speed,
        if (heading != null) 'heading': heading,
        if (recordedAt != null)
          'recorded_at': recordedAt!.toUtc().toIso8601String(),
      };
}

/// Body of POST /driver/location: the latest fix plus any buffered ones.
class LocationRequest {
  const LocationRequest({required this.current, this.buffered = const []});

  final LocationPoint current;
  final List<LocationPoint> buffered;

  Map<String, dynamic> toJson() => {
        ...current.toJson(),
        if (buffered.isNotEmpty)
          'points': buffered.map((e) => e.toJson()).toList(),
      };
}
