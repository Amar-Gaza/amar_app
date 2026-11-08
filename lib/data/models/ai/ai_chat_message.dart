import 'ai_chat_form.dart';
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
    this.form,
    this.formAnswered = false,
  });

  final String role;
  final String text;
  final DateTime createdAt;
  final List<AiCatalogItem> results;
  final List<String> suggestions;
  final bool canPrepareOrder;
  final int orderQuantity;
  final AiChatForm? form;
  final bool formAnswered;

  bool get isUser => role == 'user';

  AiChatMessage copyWith({bool? formAnswered}) => AiChatMessage(
    role: role,
    text: text,
    createdAt: createdAt,
    results: results,
    suggestions: suggestions,
    canPrepareOrder: canPrepareOrder,
    orderQuantity: orderQuantity,
    form: form,
    formAnswered: formAnswered ?? this.formAnswered,
  );

  Map<String, dynamic> toJson() => {
    'role': role, 'text': text, 'created_at': createdAt.toIso8601String(),
    'results': results.map((e) => e.toJson()).toList(),
    'suggestions': suggestions,
    'can_prepare_order': canPrepareOrder,
    'order_quantity': orderQuantity,
    'form': form?.toJson(),
    'form_answered': formAnswered,
  };

  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    final role = json['role'] is String ? json['role'] as String
        : (json['user'] == true ? 'user' : 'assistant');
    final content = json['text'];
    if (!const {'user','assistant'}.contains(role) ||
        content is! String || content.length > 2000) {
      throw const FormatException('Invalid AI chat message');
    }
    final results = <AiCatalogItem>[];
    for (final value in (json['results'] is List ? json['results'] as List : const []).take(8)) {
      if (value is! Map) continue;
      try { results.add(AiCatalogItem.fromJson(Map<String, dynamic>.from(value))); }
      on FormatException { /* Ignore one corrupt record. */ }
    }
    AiChatForm? form;
    if (json['form'] is Map) {
      try { form = AiChatForm.fromJson(Map<String, dynamic>.from(json['form'] as Map)); }
      catch (_) { /* Ignore a corrupt saved form. */ }
    }
    return AiChatMessage(
      role: role,
      text: content,
      createdAt: DateTime.tryParse('${json['created_at'] ?? ''}') ?? DateTime.now(),
      results: results,
      suggestions: (json['suggestions'] is List ? json['suggestions'] as List : const [])
          .whereType<String>().take(4).toList(),
      canPrepareOrder: json['can_prepare_order'] == true,
      orderQuantity: json['order_quantity'] is int ? json['order_quantity'] as int : 1,
      form: form,
      formAnswered: json['form_answered'] == true,
    );
  }
}
