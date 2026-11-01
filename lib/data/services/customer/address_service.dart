import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../models/masar/masar_models.dart';
import '../../models/requests/address_request.dart';

class AddressService {
  AddressService(this._client);

  final ApiClient _client;

  Address _parse(Object? data) => ApiClient.parseObject(data, Address.fromJson);

  Future<List<Address>> list() => _client.data<List<Address>>(
        HttpMethod.get,
        ApiEndpoints.addresses,
        parse: (data) => ApiClient.parseList(data, Address.fromJson),
      );

  Future<Address> create(AddressRequest request) => _client.data<Address>(
        HttpMethod.post,
        ApiEndpoints.addresses,
        body: request.toJson(),
        parse: _parse,
      );

  Future<Address> update(int id, AddressRequest request) =>
      _client.data<Address>(
        HttpMethod.put,
        ApiEndpoints.address(id),
        body: request.toJson(),
        parse: _parse,
      );

  Future<void> delete(int id) =>
      _client.command(HttpMethod.delete, ApiEndpoints.address(id));
}
