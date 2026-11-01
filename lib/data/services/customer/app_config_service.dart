import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/network/api_client.dart';
import '../../models/masar/masar_models.dart';

class AppConfigService {
  AppConfigService(this._client);

  final ApiClient _client;

  /// Returns null when the server answers 304 (cached config is current).
  Future<AppConfig?> fetch({String app = ApiQuery.appUser}) async {
    final envelope = await _client.send<AppConfig>(
      HttpMethod.get,
      ApiEndpoints.appConfig,
      query: {ApiQuery.app: app},
      skipAuth: true,
      parse: (data) =>
          AppConfig.fromJson(Map<String, dynamic>.from(data! as Map)),
    );
    return envelope?.data;
  }
}
