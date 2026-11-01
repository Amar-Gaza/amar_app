import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/network/api_client.dart';
import '../../models/masar/masar_models.dart';

class DriverProfileService {
  DriverProfileService(this._client);

  final ApiClient _client;

  Driver _parse(Object? data) => ApiClient.parseObject(data, Driver.fromJson);

  Future<Driver> me() => _client.data<Driver>(
        HttpMethod.get,
        ApiEndpoints.driverMe,
        parse: _parse,
      );

  Future<Driver> update({
    String? locale,
    String? vehicleType,
    int? avatarUploadId,
  }) =>
      _client.data<Driver>(
        HttpMethod.put,
        ApiEndpoints.driverMe,
        body: {
          if (locale != null) ApiBody.locale: locale,
          if (vehicleType != null) ApiBody.vehicleType: vehicleType,
          if (avatarUploadId != null) ApiBody.avatarUploadId: avatarUploadId,
        },
        parse: _parse,
      );

  Future<Driver> setOnline({required bool online}) => _client.data<Driver>(
        HttpMethod.put,
        ApiEndpoints.driverStatus,
        body: {ApiBody.isOnline: online},
        parse: _parse,
      );

  Future<bool> updateFcmToken(String? token) => _client.data<bool>(
        HttpMethod.put,
        ApiEndpoints.driverFcmToken,
        body: {ApiBody.token: token},
        parse: (data) => (data! as Map)['has_fcm_token'] as bool,
      );
}
