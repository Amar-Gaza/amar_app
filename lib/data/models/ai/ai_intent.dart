/// Data returned from the authenticated AMAR gateway.
class AiCatalogItem {
  const AiCatalogItem({
    required this.id,
    required this.type,
    required this.name,
    this.description = '',
    this.imageUrl = '',
    this.price = '',
    this.vendorId,
    this.category = '',
    this.address = '',
    this.isOpenNow,
  });

  final int id;
  final String type;
  final String name;
  final String description;
  final String imageUrl;
  final String price;
  final int? vendorId;
  final String category;
  final String address;
  final bool? isOpenNow;

  factory AiCatalogItem.fromJson(
    Map<String, dynamic> json,
  ) {
    final id = json['id'];
    final type = json['type'];
    final name = json['name'];

    if (id is! int ||
        id <= 0 ||
        type is! String ||
        !const {
          'product',
          'service',
          'vendor',
          'category',
        }.contains(type) ||
        name is! String ||
        name.trim().isEmpty) {
      throw const FormatException(
        'Invalid catalog item',
      );
    }

    return AiCatalogItem(
      id: id,
      type: type,
      name: name,
      description:
          json['description'] is String ? json['description'] as String : '',
      imageUrl: json['image_url'] is String ? json['image_url'] as String : '',
      price: json['price'] is String ? json['price'] as String : '',
      vendorId: json['vendor_id'] is int ? json['vendor_id'] as int : null,
      category: json['category'] is String ? json['category'] as String : '',
      address: json['address'] is String ? json['address'] as String : '',
      isOpenNow:
          json['is_open_now'] is bool ? json['is_open_now'] as bool : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'name': name,
        'description': description,
        'image_url': imageUrl,
        'price': price,
        'vendor_id': vendorId,
        'category': category,
        'address': address,
        'is_open_now': isOpenNow,
      };

  Map<String, dynamic> toContextJson() => {
        'id': id,
        'type': type,
        'name': name,
        'price': price,
        'category': category,
        'is_open_now': isOpenNow,
      };
}

class AiGatewayReply {
  const AiGatewayReply({
    required this.action,
    required this.reply,
    required this.results,
    required this.suggestions,
    required this.partial,
    this.navigate,
    this.query = '',
    this.kind = 'any',
    this.openScreen = false,
    this.quantity = 1,
  });

  final String action;
  final String reply;
  final List<AiCatalogItem> results;
  final List<String> suggestions;
  final bool partial;
  final AiCatalogItem? navigate;
  final String query;
  final String kind;
  final bool openScreen;
  final int quantity;

  factory AiGatewayReply.fromJson(
    Map<String, dynamic> json,
  ) {
    const actions = {
      'chat',
      'search_catalog',
      'search_vendors',
      'browse_categories',
      'show_cart',
      'open_home',
      'open_result',
      'ask_clarification',
      'prepare_order',
    };

    final action = json['action'];
    final reply = json['reply'];

    if (json['ok'] != true ||
        action is! String ||
        !actions.contains(action) ||
        reply is! String ||
        reply.length > 1400) {
      throw const FormatException(
        'Invalid AI reply',
      );
    }

    final rawResults = json['results'];
    final results = <AiCatalogItem>[];

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
            // Discard invalid records only.
          }
        }
      }
    }

    AiCatalogItem? navigate;

    if (json['navigate'] is Map) {
      try {
        navigate = AiCatalogItem.fromJson(
          Map<String, dynamic>.from(
            json['navigate'] as Map,
          ),
        );
      } on FormatException {
        // Ignore malformed navigation.
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

    return AiGatewayReply(
      action: action,
      reply: reply,
      results: results,
      suggestions: suggestions,
      partial: json['partial'] == true,
      navigate: navigate,
      query: json['query'] is String ? json['query'] as String : '',
      kind: json['kind'] is String ? json['kind'] as String : 'any',
      openScreen: json['open_screen'] == true,
      quantity: json['quantity'] is int &&
              json['quantity'] >= 1 &&
              json['quantity'] <= 20
          ? json['quantity'] as int
          : 1,
    );
  }
}
