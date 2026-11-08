import 'package:dio/dio.dart';

import '../../data/models/ai/ai_intent.dart';
import '../constants/app_env.dart';
import '../storage/secure_token_storage.dart';

class AiGatewayException implements Exception {
  const AiGatewayException(this.code);

  final String code;

  @override
  String toString() => 'AiGatewayException: $code';
}

class AiGatewayClient {
  AiGatewayClient(this._tokens)
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppEnv.aiGatewayUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 45),
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
            headers: const {
              'Accept': 'application/json',
            },
            validateStatus: (status) => status != null && status < 500,
          ),
        );

  final SecureTokenStorage _tokens;
  final Dio _dio;

  Future<AiGatewayReply> chat({
    required String message,
    required String locale,
    required List<Map<String, String>> history,
    required List<AiCatalogItem> lastResults,
  }) async {
    if (!AppEnv.aiGatewayUrl.startsWith('https://')) {
      throw const AiGatewayException(
        'gateway_not_configured',
      );
    }

    final token = await _tokens.read(
      SessionRole.customer,
    );

    if (token == null || token.trim().isEmpty) {
      throw const AiGatewayException(
        'unauthenticated',
      );
    }

    try {
      final response = await _dio.post<dynamic>(
        '/v1/ai/chat',
        data: {
          'message': message,
          'locale': locale == 'en' ? 'en' : 'ar',
          'history': history.take(12).toList(),
          'last_results':
              lastResults.take(8).map((x) => x.toContextJson()).toList(),
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200 || response.data is! Map) {
        throw AiGatewayException(
          _error(response.data),
        );
      }

      try {
        return AiGatewayReply.fromJson(
          Map<String, dynamic>.from(
            response.data as Map,
          ),
        );
      } on FormatException {
        throw const AiGatewayException(
          'invalid_ai_response',
        );
      }
    } on AiGatewayException {
      rethrow;
    } on DioException catch (error) {
      throw AiGatewayException(
        _error(
          error.response?.data,
          status: error.response?.statusCode,
        ),
      );
    } catch (_) {
      // Never expose authentication credentials.
      throw const AiGatewayException(
        'network_error',
      );
    }
  }

  static String _error(
    Object? value, {
    int? status,
  }) {
    if (value is Map) {
      final code = value['error']?.toString() ?? 'gateway_error';

      final upstream = value['upstream_status'];
      final detail = value['upstream_code'];

      return [
        code,
        if (upstream != null) 'HTTP $upstream',
        if (detail != null) '$detail',
      ].join(' | ');
    }

    return status == null ? 'network_error' : 'gateway_http_$status';
  }
}
