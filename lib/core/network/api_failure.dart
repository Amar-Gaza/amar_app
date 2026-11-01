import '../constants/api_query.dart';
import '../../data/models/masar/masar_models.dart';

class ApiFailure implements Exception {
  const ApiFailure({
    required this.code,
    this.message = '',
    this.requestId,
    this.statusCode,
    this.details,
  });

  factory ApiFailure.fromError(
    ApiError error, {
    String message = '',
    String? requestId,
    int? statusCode,
  }) =>
      ApiFailure(
        code: error.code,
        message: message,
        requestId: requestId,
        statusCode: statusCode,
        details: error.details,
      );

  final String code;
  final String message;
  final String? requestId;
  final int? statusCode;
  final Map<String, dynamic>? details;

  bool get isValidation => code == ApiErrorCodes.validationFailed;
  bool get isConnectivity => ApiErrorCodes.isConnectivity(code);
  bool get isUnavailable => ApiErrorCodes.isUnavailable(code);

  String? fieldError(String field) {
    final fields = details?['fields'];
    if (fields is! Map || fields[field] == null) return null;
    final value = fields[field];
    return value is List && value.isNotEmpty
        ? value.first.toString()
        : value.toString();
  }
}
