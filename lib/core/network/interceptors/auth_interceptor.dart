import 'package:dio/dio.dart';

import '../../constants/api_endpoints.dart';
import '../../constants/api_headers.dart';
import '../../constants/api_query.dart';
import '../../storage/secure_token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokens);

  final SecureTokenStorage _tokens;

  static SessionRole roleOf(String path) =>
      path.startsWith(ApiEndpoints.driverPrefix)
          ? SessionRole.driver
          : SessionRole.customer;

  /// Explicit role from the request (shared endpoints), else by path.
  static SessionRole resolve(RequestOptions options) =>
      options.extra[ApiExtra.role] as SessionRole? ?? roleOf(options.path);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[ApiExtra.skipAuth] != true) {
      final token = await _tokens.read(resolve(options));
      if (token != null && token.isNotEmpty) {
        options.headers[ApiHeaders.authorization] =
            '${ApiHeaders.bearerPrefix}$token';
      }
    }
    handler.next(options);
  }
}
