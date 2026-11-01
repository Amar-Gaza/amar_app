import 'package:dio/dio.dart';

import '../../utils/app_logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.d(
      '${response.requestOptions.method} ${response.requestOptions.path} '
      '-> ${response.statusCode}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.d(
      '${err.requestOptions.method} ${err.requestOptions.path} '
      '-> ${err.response?.statusCode ?? err.type.name}',
    );
    handler.next(err);
  }
}
