/// Item of GET /cancel-reasons.
class CancelReason {
  const CancelReason({required this.key, required this.label});

  factory CancelReason.fromJson(Map<String, dynamic> json) => CancelReason(
        key: json['key'] as String,
        label: json['label'] as String,
      );

  final String key;
  final String label;
}
