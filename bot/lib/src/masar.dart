import 'config.dart';
import 'http_json.dart';

/// Masar API client: the same endpoints and headers the Flutter app uses.
class Masar {
  Masar(this._config, this._http);

  final BotConfig _config;
  final HttpJson _http;

  static const String _v1 = '/v1';
  static const String unauthenticated = 'unauthenticated';
  static const String quoteExpired = 'quote_expired';
  static const String quoteUsed = 'quote_used';

  /// Returns the envelope's `data`; throws [MasarFailure] when the
  /// envelope says it failed.
  Future<Object?> call(
    String method,
    String path, {
    String? token,
    Map<String, Object?>? query,
    Object? body,
    String? idempotencyKey,
  }) async {
    final uri = Uri.parse('${_config.baseUrl}$_v1$path').replace(
      queryParameters: query == null
          ? null
          : {
              for (final e in query.entries)
                if (e.value != null) e.key: '${e.value}',
            },
    );
    final res = await _http.send(method, uri, body: body, headers: {
      'X-Project-Key': _config.projectKey,
      'Accept': 'application/json',
      'Accept-Language': 'ar',
      'X-App-Version': '1.0.0',
      if (_config.devMember.isNotEmpty) 'X-Dev-Member': _config.devMember,
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      if (idempotencyKey != null) 'Idempotency-Key': idempotencyKey,
    });
    final json = res.body;
    if (res.status == 401) {
      throw MasarFailure(unauthenticated, json['message']?.toString());
    }
    if (json['success'] != true || res.status >= 400) {
      final error = json['error'];
      final code = error is Map ? error['code']?.toString() : null;
      throw MasarFailure(code ?? 'server_error', json['message']?.toString());
    }
    return json['data'];
  }

  // ---- auth ----

  Future<void> sendOtp(String phone) =>
      call('POST', '/auth/send-otp', body: {'phone': phone});

  /// Returns the customer token.
  Future<String> verifyOtp(String phone, String code, {String? name}) async {
    final data = await call('POST', '/auth/verify-otp', body: {
      'phone': phone,
      'code': code,
      'device_name': 'Telegram bot',
      if (name != null) 'name': name,
    });
    return (data as Map)['token'] as String;
  }

  Future<void> logout(String token) =>
      call('POST', '/auth/logout', token: token);

  // ---- catalog ----

  Future<Map<String, dynamic>> config() async =>
      _map(await call('GET', '/app/config'));

  Future<List<Map<String, dynamic>>> vendors(String token) async => _list(
      await call('GET', '/vendors', token: token, query: {'per_page': 30}));

  Future<List<Map<String, dynamic>>> products(
          String token, int vendorId) async =>
      _list(await call('GET', '/products',
          token: token, query: {'vendor': vendorId, 'per_page': 40}));

  Future<Map<String, dynamic>> product(String token, int id) async =>
      _map(await call('GET', '/products/$id', token: token));

  // ---- addresses ----

  Future<List<Map<String, dynamic>>> addresses(String token) async =>
      _list(await call('GET', '/addresses', token: token));

  Future<Map<String, dynamic>> addAddress(
    String token, {
    required double lat,
    required double lng,
    required String label,
    String? details,
  }) async =>
      _map(await call('POST', '/addresses', token: token, body: {
        'label': label,
        'lat': lat,
        'lng': lng,
        if (details != null) 'details': details,
      }));

  // ---- orders ----

  Future<Map<String, dynamic>> quote(
    String token, {
    required int vendorId,
    required List<Map<String, dynamic>> cart,
    required int addressId,
    String? paymentMethod,
  }) async =>
      _map(await call('POST', '/orders/quote', token: token, body: {
        'vendor_id': vendorId,
        'cart': cart,
        'dropoff_address_id': addressId,
        if (paymentMethod != null) 'payment_method': paymentMethod,
      }));

  Future<Map<String, dynamic>> placeOrder(
    String token, {
    required String quoteToken,
    required String idempotencyKey,
    String? note,
  }) async =>
      _map(await call('POST', '/orders',
          token: token,
          idempotencyKey: idempotencyKey,
          body: {
            'quote_token': quoteToken,
            if (note != null) 'note': note,
          }));

  Future<List<Map<String, dynamic>>> orders(String token) async =>
      _list(await call('GET', '/orders', token: token, query: {'per_page': 5}));

  Future<Map<String, dynamic>> order(String token, int id) async =>
      _map(await call('GET', '/orders/$id', token: token));

  Future<Map<String, dynamic>> offer(String token, int orderId) async =>
      _map(await call('GET', '/orders/$orderId/offer', token: token));

  Future<void> approveOffer(String token, int orderId, int offerId) =>
      call('POST', '/orders/$orderId/offer/approve',
          token: token, body: {'offer_id': offerId});

  Future<void> rejectOffer(String token, int orderId, int offerId) =>
      call('POST', '/orders/$orderId/offer/reject',
          token: token, body: {'offer_id': offerId});

  static Map<String, dynamic> _map(Object? data) =>
      Map<String, dynamic>.from(data! as Map);

  static List<Map<String, dynamic>> _list(Object? data) =>
      ((data as List?) ?? const [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
}

class MasarFailure implements Exception {
  const MasarFailure(this.code, [this.message]);
  final String code;
  final String? message;

  @override
  String toString() => 'MasarFailure($code): $message';
}

/// Reads a label that may be a plain string or an {ar, en} map.
String labelOf(Object? value) {
  if (value is String) return value;
  if (value is Map) return (value['ar'] ?? value['en'] ?? '').toString();
  return '';
}

/// Reads the `formatted` text of a Money object.
String moneyOf(Object? value) =>
    value is Map ? (value['formatted'] ?? '').toString() : '';
