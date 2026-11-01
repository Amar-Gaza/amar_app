/// Body of POST /orders.
class PlaceOrderRequest {
  const PlaceOrderRequest({
    required this.quoteToken,
    this.fields = const {},
    this.uploadIds = const [],
    this.note,
  });

  final String quoteToken;
  final Map<String, dynamic> fields;
  final List<int> uploadIds;
  final String? note;

  Map<String, dynamic> toJson() => {
        'quote_token': quoteToken,
        if (fields.isNotEmpty) 'fields': fields,
        if (uploadIds.isNotEmpty) 'upload_ids': uploadIds,
        if (note != null) 'note': note,
      };
}
