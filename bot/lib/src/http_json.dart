import 'dart:convert';
import 'dart:io';

/// Status code plus decoded JSON body (empty map when there is none).
typedef JsonResponse = ({int status, Map<String, dynamic> body});

/// Small JSON-over-HTTP helper on dart:io, so the bot needs no packages.
class HttpJson {
  HttpJson({Duration connectTimeout = const Duration(seconds: 15)})
      : _client = HttpClient()..connectionTimeout = connectTimeout;

  final HttpClient _client;

  Future<JsonResponse> send(
    String method,
    Uri uri, {
    Map<String, String> headers = const {},
    Object? body,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final request = await _client.openUrl(method, uri);
    headers.forEach(request.headers.set);
    if (body != null) {
      request.headers.contentType = ContentType.json;
      request.add(utf8.encode(jsonEncode(body)));
    }
    final response = await request.close().timeout(timeout);
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
