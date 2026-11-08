import 'ai_intent.dart';

/// Persisted pre-checkout choices. Never represents an authorized order.
abstract final class AiDraftStage {
  static const vendor = 'vendor';
  static const product = 'product';
  static const options = 'options';
  static const address = 'address';
  static const payment = 'payment';
  static const review = 'review';
  static const finished = 'finished';
}

class AiOrderDraft {
  AiOrderDraft({
    required this.query,
    required this.candidates,
    required this.quantity,
    this.stage = AiDraftStage.vendor,
    this.vendorId,
    this.productId,
    this.addressId,
    this.paymentMethod,
    this.paymentGatewayId,
    this.optionsSummary,
    this.addressLabel,
    this.paymentLabel,
    Map<String, List<String>>? options,
    Map<int, String>? vendorNames,
  }) : options = options ?? <String, List<String>>{},
       vendorNames = vendorNames ?? <int, String>{};

  final String query;
  final List<AiCatalogItem> candidates;
  String stage;
  int quantity;
  int? vendorId;
  int? productId;
  int? addressId;
  String? paymentMethod;
  int? paymentGatewayId;
  String? optionsSummary;
  String? addressLabel;
  String? paymentLabel;
  final Map<String, List<String>> options;
  final Map<int, String> vendorNames;

  AiCatalogItem? get selectedItem {
    for (final item in candidates) {
      if (item.id == productId) return item;
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    'query': query,
    'candidates': candidates.map((e) => e.toJson()).toList(),
    'stage': stage,
    'quantity': quantity,
    'vendor_id': vendorId,
    'product_id': productId,
    'address_id': addressId,
    'payment_method': paymentMethod,
    'payment_gateway_id': paymentGatewayId,
    'options_summary': optionsSummary,
    'address_label': addressLabel,
    'payment_label': paymentLabel,
    'options': options,
    'vendor_names': vendorNames.map((id, name) => MapEntry('$id', name)),
  };

  factory AiOrderDraft.fromJson(Map<String, dynamic> json) => AiOrderDraft(
    query: json['query'] as String,
    candidates: ((json['candidates'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => AiCatalogItem.fromJson(Map<String, dynamic>.from(e)))
        .take(8).toList(),
    stage: json['stage'] as String? ?? AiDraftStage.vendor,
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    vendorId: (json['vendor_id'] as num?)?.toInt(),
    productId: (json['product_id'] as num?)?.toInt(),
    addressId: (json['address_id'] as num?)?.toInt(),
    paymentMethod: json['payment_method'] as String?,
    paymentGatewayId: (json['payment_gateway_id'] as num?)?.toInt(),
    optionsSummary: json['options_summary'] as String?,
    addressLabel: json['address_label'] as String?,
    paymentLabel: json['payment_label'] as String?,
    vendorNames: {
      if (json['vendor_names'] is Map)
        for (final entry in (json['vendor_names'] as Map).entries)
          if (int.tryParse('${entry.key}') != null && entry.value is String)
            int.parse('${entry.key}'): entry.value as String,
    },
    options: {
      if (json['options'] is Map)
        for (final entry in (json['options'] as Map).entries)
          if (entry.key is String && entry.value is List)
            entry.key as String: (entry.value as List).whereType<String>().toList(),
    },
  );
}
