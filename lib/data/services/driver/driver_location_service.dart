import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../models/requests/location_request.dart';

class DriverLocationService {
  DriverLocationService(this._client);

  final ApiClient _client;

  /// Returns how many points the server stored.
  Future<int> send(LocationRequest request) => _client.data<int>(
        HttpMethod.post,
        ApiEndpoints.driverLocation,
        body: request.toJson(),
        parse: (data) => ((data! as Map)['stored'] as num).toInt(),
      );
}
