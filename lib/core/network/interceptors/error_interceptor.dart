import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../constants/api_headers.dart';
import '../../constants/api_query.dart';
import '../../../data/models/masar/masar_models.dart';
import '../api_failure.dart';
import '../session_events.dart';
import 'auth_interceptor.dart';

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor(this._events);

  final SessionEvents _events;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _toFailure(err);
    if (kDebugMode) {
      debugPrint(
          '${err.requestOptions.method} ${err.requestOptions.path} -> $failure');
    }
    final hadToken =
        err.requestOptions.headers.containsKey(ApiHeaders.authorization);
    if (failure.code == ApiErrorCodes.unauthenticated && hadToken) {
      _events.emitUnauthorized(AuthInterceptor.resolve(err.requestOptions));
    }
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: failure,
      ),
    );
  }

  ApiFailure _toFailure(DioException err) {
    if (err.error is ApiFailure) return err.error! as ApiFailure;
    final data = err.response?.data;
    final status = err.response?.statusCode;
    if (data is Map && data['error'] is Map) {
      return ApiFailure.fromError(
        ApiError.fromJson(Map<String, dynamic>.from(data['error'] as Map)),
        message: (data['message'] as String?) ?? '',
        requestId: data['request_id'] as String?,
        statusCode: status,
      );
    }
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiFailure(code: ApiErrorCodes.timeout);
      case DioExceptionType.connectionError:
        return const ApiFailure(code: ApiErrorCodes.networkError);
      case DioExceptionType.badCertificate:
        return const ApiFailure(code: ApiErrorCodes.secureConnection);
      case DioExceptionType.unknown when err.error is SocketException:
        return const ApiFailure(code: ApiErrorCodes.networkError);
      case DioExceptionType.badResponse:
        // A reply without the error envelope (proxy page, HTML, empty body).
        return ApiFailure(
          code: ApiErrorCodes.fromStatus(status),
          statusCode: status,
        );
      default:
        return ApiFailure(
          code: status == null
              ? ApiErrorCodes.networkError
              : ApiErrorCodes.fromStatus(status),
          statusCode: status,
        );
    }
  }
}
