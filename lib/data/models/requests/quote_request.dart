import 'place_input.dart';

/// One catalog cart line. Options map option key → choice key(s).
class CartLine {
  const CartLine({
    required this.productId,
    this.qty = 1,
    this.options = const {},
    this.note,
  });

  final int productId;
  final int qty;
  final Map<String, Object> options;
  final String? note;

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'qty': qty,
        if (options.isNotEmpty) 'options': options,
        if (note != null) 'note': note,
      };
}

/// Free-text item (non-catalog orders).
class QuoteItem {
  const QuoteItem({required this.name, this.qty = 1, this.note});

  final String name;
  final int qty;
  final String? note;

  Map<String, dynamic> toJson() => {
        'name': name,
        'qty': qty,
        if (note != null) 'note': note,
      };
}

/// Body of POST /orders/quote. The app sends places, items and fields;
/// the server computes every price.
class QuoteRequest {
  const QuoteRequest({
    this.vendorId,
    this.cart = const [],
    this.items = const [],
    this.dropoffAddressId,
    this.dropoff,
    this.pickup,
    this.fields = const {},
    this.paymentMethod,
    this.scheduledFor,
    this.coupon,
    this.paymentGatewayId,
    this.printItems = const [],
  });

  final int? vendorId;
  final List<CartLine> cart;
  final List<QuoteItem> items;
  final int? dropoffAddressId;
  final PlaceInput? dropoff;
  final PlaceInput? pickup;
  final Map<String, dynamic> fields;
  final String? paymentMethod;
  final DateTime? scheduledFor;
  final String? coupon;
  final int? paymentGatewayId;

  /// Printing module jobs, passed through as the server defines them.
  final List<Map<String, dynamic>> printItems;

  Map<String, dynamic> toJson() => {
        if (vendorId != null) 'vendor_id': vendorId,
        if (cart.isNotEmpty) 'cart': cart.map((e) => e.toJson()).toList(),
        if (items.isNotEmpty) 'items': items.map((e) => e.toJson()).toList(),
        if (dropoffAddressId != null) 'dropoff_address_id': dropoffAddressId,
        if (dropoff != null) 'dropoff': dropoff!.toJson(),
        if (pickup != null) 'pickup': pickup!.toJson(),
        if (fields.isNotEmpty) 'fields': fields,
        if (paymentMethod != null) 'payment_method': paymentMethod,
        if (scheduledFor != null)
          'scheduled_for': scheduledFor!.toUtc().toIso8601String(),
        if (coupon != null) 'coupon': coupon,
        if (paymentGatewayId != null) 'payment_gateway_id': paymentGatewayId,
        if (printItems.isNotEmpty) 'print_items': printItems,
      };
}
