/// Free location used for quote pickup / dropoff.
class PlaceInput {
  const PlaceInput({
    required this.lat,
    required this.lng,
    this.label,
    this.details,
  });

  final double lat;
  final double lng;
  final String? label;
  final String? details;

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        if (label != null) 'label': label,
        if (details != null) 'details': details,
      };
}
