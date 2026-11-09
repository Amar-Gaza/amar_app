import 'dart:convert';
import 'dart:io';

/// What the bot waits for next in a chat.
enum Step { idle, contact, otp, location, details }

class CartLine {
  CartLine(this.productId, this.name, this.qty);

  final int productId;
  final String name;
  int qty;

  Map<String, dynamic> toJson() =>
      {'product_id': productId, 'name': name, 'qty': qty};

  factory CartLine.fromJson(Map<String, dynamic> json) => CartLine(
      json['product_id'] as int, json['name'] as String, json['qty'] as int);
}

/// One Telegram chat: login, cart, checkout progress and followed orders.
class Session {
  Session();

  Step step = Step.idle;
  String? phone;
  String? token;

  int? vendorId;
  String? vendorName;
  List<CartLine> cart = [];
  int? pendingProductId;
  String? pendingProductName;

  double? lat;
  double? lng;
  int? addressId;
  String? quoteToken;
  String? idempotencyKey;

  /// Order id → last status key the customer was told about.
  Map<String, String> watched = {};

  /// Offer ids already shown, so an offer is sent once.
  Set<int> shownOffers = {};

  bool get signedIn => token != null;

  void clearCheckout() {
    lat = null;
    lng = null;
    addressId = null;
    quoteToken = null;
    idempotencyKey = null;
  }

  void clearCart() {
    cart = [];
    vendorId = null;
    vendorName = null;
    pendingProductId = null;
    pendingProductName = null;
    clearCheckout();
  }

  void signOut() {
    clearCart();
    token = null;
    phone = null;
    watched = {};
    shownOffers = {};
    step = Step.idle;
  }

  Map<String, dynamic> toJson() => {
        'step': step.name,
        'phone': phone,
        'token': token,
        'vendor_id': vendorId,
        'vendor_name': vendorName,
        'cart': cart.map((e) => e.toJson()).toList(),
        'pending_product_id': pendingProductId,
        'pending_product_name': pendingProductName,
        'lat': lat,
        'lng': lng,
        'address_id': addressId,
        'quote_token': quoteToken,
        'idempotency_key': idempotencyKey,
        'watched': watched,
        'shown_offers': shownOffers.toList(),
      };

  factory Session.fromJson(Map<String, dynamic> json) => Session()
    ..step = Step.values.asNameMap()[json['step']] ?? Step.idle
    ..phone = json['phone'] as String?
    ..token = json['token'] as String?
    ..vendorId = json['vendor_id'] as int?
    ..vendorName = json['vendor_name'] as String?
    ..cart = ((json['cart'] as List?) ?? const [])
        .map((e) => CartLine.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList()
    ..pendingProductId = json['pending_product_id'] as int?
    ..pendingProductName = json['pending_product_name'] as String?
    ..lat = (json['lat'] as num?)?.toDouble()
    ..lng = (json['lng'] as num?)?.toDouble()
    ..addressId = json['address_id'] as int?
    ..quoteToken = json['quote_token'] as String?
    ..idempotencyKey = json['idempotency_key'] as String?
    ..watched = Map<String, String>.from((json['watched'] as Map?) ?? const {})
    ..shownOffers = ((json['shown_offers'] as List?) ?? const [])
        .map((e) => e as int)
        .toSet();
}

/// Sessions saved as one JSON file. Holds customer tokens, so the data
/// folder stays out of git and on the bot host only.
class SessionStore {
  SessionStore(String dataDir) : _file = File('$dataDir/sessions.json');

  final File _file;
  final Map<int, Session> _sessions = {};

  Iterable<MapEntry<int, Session>> get entries => _sessions.entries;

  Session of(int chatId) => _sessions.putIfAbsent(chatId, Session.new);

  void load() {
    if (!_file.existsSync()) return;
    final json = jsonDecode(_file.readAsStringSync()) as Map;
    json.forEach((key, value) {
      _sessions[int.parse(key as String)] =
          Session.fromJson(Map<String, dynamic>.from(value as Map));
    });
  }

  Future<void> _saving = Future<void>.value();

  /// Saves run one after another (chats are handled in parallel), and a
  /// failed write is logged instead of stopping the bot.
  Future<void> save() => _saving = _saving.then((_) async {
        try {
          await _write();
        } on Object catch (e) {
          stderr.writeln('save sessions: $e');
        }
      });

  Future<void> _write() async {
    await _file.parent.create(recursive: true);
    final tmp = File('${_file.path}.tmp');
    await tmp.writeAsString(jsonEncode({
      for (final e in _sessions.entries) '${e.key}': e.value.toJson(),
    }));
    await tmp.rename(_file.path);
  }
}
