/// Body of POST /vendor-applications.
class VendorApplicationRequest {
  const VendorApplicationRequest({
    required this.businessName,
    required this.contactName,
    required this.phone,
    this.category,
    this.lat,
    this.lng,
    this.note,
  });

  final String businessName;
  final String contactName;
  final String phone;
  final String? category;
  final double? lat;
  final double? lng;
  final String? note;

  Map<String, dynamic> toJson() => {
        'business_name': businessName,
        'contact_name': contactName,
        'phone': phone,
        if (category != null) 'category': category,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
        if (note != null) 'note': note,
      };
}
