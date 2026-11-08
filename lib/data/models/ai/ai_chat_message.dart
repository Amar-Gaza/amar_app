import 'ai_intent.dart';

class AiChatMessage {
  const AiChatMessage({
    required this.role,
    required this.text,
    required this.createdAt,
    this.results = const [],
    this.suggestions = const [],
    this.canPrepareOrder = false,
    this.orderQuantity = 1,
  });

  final String role;
  final String text;
  final DateTime createdAt;
  final List<AiCatalogItem> results;
  final List<String> suggestions;
  final bool canPrepareOrder;
  final int orderQuantity;

  bool get isUser => role == 'user';

  Map<String, dynamic> toJson() => {
        'role': role,
        'text': text,
        'created_at': createdAt.toIso8601String(),
        'results': results.map((item) => item.toJson()).toList(),
        'suggestions': suggestions,
        'can_prepare_order': canPrepareOrder,
        'order_quantity': orderQuantity,
      };

  factory AiChatMessage.fromJson(
    Map<String, dynamic> json,
  ) {
    final role = json['role'] is String
        ? json['role'] as String
        : (json['user'] == true ? 'user' : 'assistant');

    final text = json['text'];

    if (!const {
          'user',
          'assistant',
        }.contains(role) ||
        text is! String ||
        text.length > 2000) {
      throw const FormatException(
        'Invalid AI history',
      );
    }

    final results = <AiCatalogItem>[];
    final rawResults = json['results'];

    if (rawResults is List) {
      for (final row in rawResults.take(8)) {
        if (row is Map) {
          try {
            results.add(
              AiCatalogItem.fromJson(
                Map<String, dynamic>.from(row),
              ),
            );
          } on FormatException {
            // Keep valid saved entries.
          }
        }
      }
    }

    final suggestions = <String>[];

    if (json['suggestions'] is List) {
      for (final value in (json['suggestions'] as List).take(4)) {
        if (value is String && value.length <= 100) {
          suggestions.add(value);
        }
      }
    }

    return AiChatMessage(
      role: role,
      text: text,
      createdAt: DateTime.tryParse(
            json['created_at']?.toString() ?? '',
          ) ??
          DateTime.now(),
      results: results,
      suggestions: suggestions,
      canPrepareOrder: json['can_prepare_order'] == true,
      orderQuantity: json['order_quantity'] is int &&
              json['order_quantity'] >= 1 &&
              json['order_quantity'] <= 20
          ? json['order_quantity'] as int
          : 1,
    );
  }
}
