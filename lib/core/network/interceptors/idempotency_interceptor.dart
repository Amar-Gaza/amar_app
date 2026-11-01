import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../constants/api_headers.dart';
import '../../constants/api_query.dart';

class IdempotencyInterceptor extends Interceptor {
  static const Uuid _uuid = Uuid();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final needsKey = options.extra[ApiExtra.idempotent] == true;
    if (needsKey && !options.headers.containsKey(ApiHeaders.idempotencyKey)) {
      options.headers[ApiHeaders.idempotencyKey] = _uuid.v4();
    }
    handler.next(options);
  }
}
