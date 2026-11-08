import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Status code plus decoded JSON body (empty map when there is none).
typedef JsonResponse = ({int status, Map<String, dynamic> body});

/// Small JSON-over-HTTP helper on dart:io, so the bot needs no packages.
class HttpJson {
  HttpJson({Duration connectTimeout = const Duration(seconds: 15)})
      : _client = HttpClient()
          ..connectionTimeout = connectTimeout
          // Drop idle sockets early: a reused socket the network already
          // cut can hang a request until it times out.
          ..idleTimeout = const Duration(seconds: 5);

  final HttpClient _client;

  /// Sends once and retries once on a network error or timeout. Order
  /// placement is safe to retry because it carries an Idempotency-Key.
  Future<JsonResponse> send(
    String method,
    Uri uri, {
    Map<String, String> headers = const {},
    Object? body,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      return await _once(method, uri, headers, body).timeout(timeout);
    } on TimeoutException {
      return _once(method, uri, headers, body, fresh: true).timeout(timeout);
    } on IOException {
      return _once(method, uri, headers, body, fresh: true).timeout(timeout);
    }
  }

  Future<JsonResponse> _once(
    String method,
    Uri uri,
    Map<String, String> headers,
    Object? body, {
    bool fresh = false,
  }) async {
    final request = await _client.openUrl(method, uri);
    if (fresh) request.persistentConnection = false;
    headers.forEach(request.headers.set);
    if (body != null) {
      request.headers.contentType = ContentType.json;
      request.add(utf8.encode(jsonEncode(body)));
    }
    final response = await request.close();
    final text = await response.transform(utf8.decoder).join();
    final decoded = text.isEmpty ? null : jsonDecode(text);
    return (
      status: response.statusCode,
      body: decoded is Map
          ? Map<String, dynamic>.from(decoded)
          : <String, dynamic>{},
    );
  }

  void close() => _client.close(force: true);
}
