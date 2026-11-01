import '../masar/masar_models.dart';
import '../requests/quote_request.dart';

/// A product line the customer has added. Prices stay indicative: the
/// server prices every line on POST /orders/quote.
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

  /// Same product with the same choices merges into one line.
  String get key {
    final parts = options.entries
        .map((e) => '${e.key}=${([...e.value]..sort()).join('|')}')
        .toList()
      ..sort();
    return '${product.id}#${parts.join(';')}';
  }

  /// Labels of the selected choices, in option order.
  List<String> get choiceLabels => [
        for (final option in product.options)
          for (final choice in option.choices)
            if (options[option.key]?.contains(choice.key) ?? false)
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
              option.key: option.type == ProductOptionType.multi
                  ? options[option.key]!
                  : options[option.key]!.first,
        },
      );
}

abstract final class ProductOptionType {
  static const String single = 'single';
  static const String multi = 'multi';
}
