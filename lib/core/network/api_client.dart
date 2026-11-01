import 'package:dio/dio.dart';

import '../../data/models/api/paged.dart';
import '../../data/models/masar/masar_models.dart';
import '../constants/api_headers.dart';
import '../constants/api_query.dart';
import '../constants/app_durations.dart';
import '../constants/app_env.dart';
import '../storage/app_preferences.dart';
import '../storage/secure_token_storage.dart';
import 'api_failure.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/headers_interceptor.dart';
import 'interceptors/idempotency_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'session_events.dart';

enum HttpMethod { get, post, put, delete }

class ApiClient {
  ApiClient({
    required AppPreferences prefs,
    required SecureTokenStorage tokens,
    required SessionEvents events,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: AppEnv.baseUrl,
            connectTimeout: AppDurations.connect,
            receiveTimeout: AppDurations.receive,
            contentType: ApiHeaders.json,
            validateStatus: (status) => status != null && status < 400,
          ),
        ) {
    _dio.interceptors.addAll([
      HeadersInterceptor(prefs),
      AuthInterceptor(tokens),
      IdempotencyInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(events),
    ]);
  }

  final Dio _dio;

  /// Returns null on 304 or an empty body.
  Future<ApiEnvelope<T>?> send<T>(
    HttpMethod method,
    String path, {
    required T Function(Object? data) parse,
    Map<String, dynamic>? query,
    Object? body,
    bool idempotent = false,
    bool skipAuth = false,
    SessionRole? role,
    String? idempotencyKey,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        path,
        data: body,
        queryParameters: query,
        onSendProgress: onSendProgress,
        options: Options(
          headers: idempotencyKey == null
              ? null
              : {ApiHeaders.idempotencyKey: idempotencyKey},
          method: method.name.toUpperCase(),
          contentType:
              body is FormData ? Headers.multipartFormDataContentType : null,
          extra: {
            ApiExtra.idempotent: idempotent,
            ApiExtra.skipAuth: skipAuth,
            if (role != null) ApiExtra.role: role,
          },
        ),
      );
      final json = response.data;
      if (response.statusCode == 304 || json is! Map) return null;
      return ApiEnvelope<T>.fromJson(Map<String, dynamic>.from(json), parse);
    } on DioException catch (e) {
      final error = e.error;
      throw error is ApiFailure
          ? error
          : const ApiFailure(code: ApiErrorCodes.serverError);
    }
  }

  Future<T> data<T>(
    HttpMethod method,
    String path, {
    required T Function(Object? data) parse,
    Map<String, dynamic>? query,
    Object? body,
    bool idempotent = false,
    bool skipAuth = false,
    SessionRole? role,
    String? idempotencyKey,
    ProgressCallback? onSendProgress,
  }) async {
    final envelope = await send<T>(
      method,
      path,
      parse: parse,
      query: query,
      body: body,
      idempotent: idempotent,
      skipAuth: skipAuth,
      role: role,
      idempotencyKey: idempotencyKey,
      onSendProgress: onSendProgress,
    );
    final value = envelope?.data;
    if (value == null) {
      throw const ApiFailure(code: ApiErrorCodes.emptyResponse);
    }
    return value;
  }

  /// For endpoints whose `data` may legitimately be null.
  Future<T?> nullable<T>(
    HttpMethod method,
    String path, {
    required T Function(Object? data) parse,
    Map<String, dynamic>? query,
  }) async {
    final envelope = await send<T>(method, path, parse: parse, query: query);
    return envelope?.data;
  }

  /// For endpoints that answer `data: null`; only success matters.
  Future<void> command(
    HttpMethod method,
    String path, {
    Object? body,
    bool idempotent = false,
  }) async {
    await send<Object?>(
      method,
      path,
      body: body,
      idempotent: idempotent,
      parse: (data) => data,
    );
  }

  /// Paginated list: `data` is an array and `meta` carries paging.
  Future<Paged<T>> page<T>(
    String path, {
    required T Function(Map<String, dynamic> json) item,
    Map<String, dynamic>? query,
    bool skipAuth = false,
  }) async {
    final envelope = await send<List<T>>(
      HttpMethod.get,
      path,
      query: query,
      skipAuth: skipAuth,
      parse: (data) => parseList(data, item),
    );
    if (envelope == null) {
      throw const ApiFailure(code: ApiErrorCodes.emptyResponse);
    }
    return Paged<T>.fromEnvelope(envelope.data ?? <T>[], envelope.meta);
  }

  static List<T> parseList<T>(
    Object? data,
    T Function(Map<String, dynamic> json) item,
  ) =>
      ((data as List?) ?? const <Object?>[])
          .map((e) => item(Map<String, dynamic>.from(e! as Map)))
          .toList();

  static T parseObject<T>(
    Object? data,
    T Function(Map<String, dynamic> json) item,
  ) =>
      item(Map<String, dynamic>.from(data! as Map));
}
