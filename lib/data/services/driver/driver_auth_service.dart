import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/network/api_client.dart';
import '../../models/api/driver_login_result.dart';

class DriverAuthService {
  DriverAuthService(this._client);

  final ApiClient _client;

  Future<DriverLoginResult> login({
    required String phone,
    required String password,
    required String deviceName,
  }) =>
      _client.data<DriverLoginResult>(
        HttpMethod.post,
        ApiEndpoints.driverLogin,
        skipAuth: true,
        body: {
          ApiBody.phone: phone,
          ApiBody.password: password,
          ApiBody.deviceName: deviceName,
        },
        parse: (data) =>
            ApiClient.parseObject(data, DriverLoginResult.fromJson),
      );

  Future<void> logout() =>
      _client.command(HttpMethod.post, ApiEndpoints.driverLogout);
}
