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

  /// Why a 409 `conflict` happened (offer_changed, offer_expired,
  /// quote_changed, ...). The server sends it in `details.reason`.
  String? get reason {
    final value = details?['reason'];
    return value is String && value.isNotEmpty ? value : null;
  }

  /// True when [value] is the error code or the conflict reason.
  bool hasReason(String value) => code == value || reason == value;

  bool get isValidation => code == ApiErrorCodes.validationFailed;
  bool get isConnectivity => ApiErrorCodes.isConnectivity(code);
  bool get isUnavailable => ApiErrorCodes.isUnavailable(code);

  /// The server's reason for the first invalid field of a 422, if any.
  String? get firstFieldError {
    final fields = details?['fields'];
    if (fields is! Map) return null;
    for (final key in fields.keys) {
      final reason = fieldError('$key');
      if (reason != null) return reason;
    }
    return null;
  }

  /// Everything a developer needs; never shown to users.
  @override
  String toString() => 'ApiFailure(code: $code, status: $statusCode, '
      'request_id: $requestId, message: $message, details: $details)';

  String? fieldError(String field) {
    final fields = details?['fields'];
    if (fields is! Map || fields[field] == null) return null;
    final value = fields[field];
    return value is List && value.isNotEmpty
        ? value.first.toString()
        : value.toString();
  }
}
