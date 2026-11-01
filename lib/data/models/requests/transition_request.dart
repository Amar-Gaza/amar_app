/// Body of POST /driver/orders/{order}/transition.
class TransitionRequest {
  const TransitionRequest({
    required this.to,
    this.fields = const {},
    this.uploadIds = const [],
    this.otp,
    this.note,
  });

  /// Target status key; must be one of the order's allowed actions.
  final String to;
  final Map<String, dynamic> fields;
  final List<int> uploadIds;
  final String? otp;
  final String? note;

  Map<String, dynamic> toJson() => {
        'to': to,
        if (fields.isNotEmpty) 'fields': fields,
        if (uploadIds.isNotEmpty) 'upload_ids': uploadIds,
        if (otp != null) 'otp': otp,
        if (note != null) 'note': note,
      };
}

/// Body of POST /driver/orders/{order}/deliver.
class DeliverRequest {
  const DeliverRequest({
    this.otp,
    this.fields = const {},
    this.uploadIds = const [],
    this.note,
  });

  final String? otp;
  final Map<String, dynamic> fields;
  final List<int> uploadIds;
  final String? note;

  Map<String, dynamic> toJson() => {
        if (otp != null) 'otp': otp,
        if (fields.isNotEmpty) 'fields': fields,
        if (uploadIds.isNotEmpty) 'upload_ids': uploadIds,
        if (note != null) 'note': note,
      };
}
