import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/network/api_client.dart';
import '../../models/auth/send_otp_result.dart';
import '../../models/auth/verify_otp_result.dart';

class AuthService {
  AuthService(this._client);

  final ApiClient _client;

  Future<SendOtpResult> sendOtp(String phone) => _client.data<SendOtpResult>(
        HttpMethod.post,
        ApiEndpoints.sendOtp,
        skipAuth: true,
        body: {ApiBody.phone: phone},
        parse: (data) =>
            SendOtpResult.fromJson(Map<String, dynamic>.from(data! as Map)),
      );

  Future<VerifyOtpResult> verifyOtp({
    required String phone,
    required String code,
    required String deviceName,
    String? name,
  }) =>
      _client.data<VerifyOtpResult>(
        HttpMethod.post,
        ApiEndpoints.verifyOtp,
        skipAuth: true,
        body: {
          ApiBody.phone: phone,
          ApiBody.code: code,
          ApiBody.deviceName: deviceName,
          if (name != null) ApiBody.name: name,
        },
        parse: (data) =>
            VerifyOtpResult.fromJson(Map<String, dynamic>.from(data! as Map)),
      );

  Future<void> logout() =>
      _client.command(HttpMethod.post, ApiEndpoints.logout);
}
