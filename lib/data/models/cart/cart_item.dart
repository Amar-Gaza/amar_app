import '../masar/masar_models.dart';
import '../requests/quote_request.dart';

/// A product line the customer has added.
/// Prices stay indicative: the server prices
/// every line on POST /orders/quote.
class CartItem {
  const CartItem({
    required this.product,
    required this.qty,
    this.options = const {},
    this.note,
  });

  final Product product;
  final int qty;

  /// Option key → selected choice keys.
  final Map<String, List<String>> options;

  final String? note;

  factory CartItem.fromJson(
      Map<String, dynamic> json,
      ) {
    final qty = json['qty'];
    final rawOptions = json['options'];
    final note = json['note'];

    if (qty is! int ||
        qty <= 0 ||
        rawOptions is! Map ||
        (note != null && note is! String)) {
      throw const FormatException(
        'Invalid saved cart line',
      );
    }

    final product = Product.fromJson(
      Map<String, dynamic>.from(
        json['product'] as Map,
      ),
    );

    if (product.id <= 0 ||
        product.vendorId == null ||
        product.vendorId! <= 0 ||
        product.kind != 'product') {
      throw const FormatException(
        'Invalid saved cart product',
      );
    }

    final options = <String, List<String>>{};

    for (final entry in rawOptions.entries) {
      if (entry.key is! String ||
          entry.value is! List ||
          (entry.value as List).any(
                (value) => value is! String,
          )) {
        throw const FormatException(
          'Invalid saved cart options',
        );
      }

      options[entry.key as String] =
      List<String>.from(
        entry.value as List,
      );
    }

    return CartItem(
      product: product,
      qty: qty,
      options: options,
      note: note as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'qty': qty,
    'options': {
      for (final entry in options.entries)
        entry.key: List<String>.from(entry.value),
    },
    'note': note,
  };

  /// Same product with the same choices
  /// merges into one line.
  String get key {
    final parts = options.entries
        .map(
          (entry) =>
      '${entry.key}=${([...entry.value]..sort()).join('|')}',
    )
        .toList()
      ..sort();

    return '${product.id}#${parts.join(';')}';
  }

  /// Labels of the selected choices,
  /// in option order.
  List<String> get choiceLabels => [
    for (final option in product.options)
      for (final choice in option.choices)
        if (options[option.key]?.contains(choice.key) ??
            false)
          choice.label,
  ];

  CartItem copyWith({int? qty}) => CartItem(
    product: product,
    qty: qty ?? this.qty,
    options: options,
    note: note,
  );

  CartLine toCartLine() => CartLine(
    productId: product.id,
    qty: qty,
    note: note,
    options: {
      for (final option in product.options)
        if (options[option.key]?.isNotEmpty ?? false)
          option.key:
          option.type == ProductOptionType.multi
              ? options[option.key]!
              : options[option.key]!.first,
    },
  );
}

abstract final class ProductOptionType {
  static const String single = 'single';
  static const String multi = 'multi';
}