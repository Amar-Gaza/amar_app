/// Body of POST /addresses and PUT /addresses/{address}.
class AddressRequest {
  const AddressRequest({
    required this.label,
    required this.lat,
    required this.lng,
    this.details,
    this.isDefault,
  });

  final String label;
  final double lat;
  final double lng;
  final String? details;
  final bool? isDefault;

  Map<String, dynamic> toJson() => {
        'label': label,
        'lat': lat,
        'lng': lng,
        if (details != null) 'details': details,
        if (isDefault != null) 'is_default': isDefault,
      };
}
