import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/network/api_client.dart';
import '../../models/masar/masar_models.dart';

class ProfileService {
  ProfileService(this._client);

  final ApiClient _client;

  User _parse(Object? data) => ApiClient.parseObject(data, User.fromJson);

  Future<User> me() =>
      _client.data<User>(HttpMethod.get, ApiEndpoints.me, parse: _parse);

  Future<User> update({String? name, String? locale, int? avatarUploadId}) =>
      _client.data<User>(
        HttpMethod.put,
        ApiEndpoints.me,
        body: {
          if (name != null) ApiBody.name: name,
          if (locale != null) ApiBody.locale: locale,
          if (avatarUploadId != null) ApiBody.avatarUploadId: avatarUploadId,
        },
        parse: _parse,
      );

  Future<void> deleteAccount() =>
      _client.command(HttpMethod.delete, ApiEndpoints.me);

  /// Pass null to unregister the device. Returns whether a token is stored.
  Future<bool> updateFcmToken(String? token) => _client.data<bool>(
        HttpMethod.put,
        ApiEndpoints.meFcmToken,
        body: {ApiBody.token: token},
        parse: (data) => (data! as Map)['has_fcm_token'] as bool,
      );
}
