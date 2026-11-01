import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/network/api_client.dart';
import '../../models/api/paged.dart';
import '../../models/masar/masar_models.dart';
import '../../models/requests/transition_request.dart';

/// Driver jobs: browse → accept → transition → deliver.
class DriverOrderService {
  DriverOrderService(this._client);

  final ApiClient _client;

  DriverOrder _parse(Object? data) =>
      ApiClient.parseObject(data, DriverOrder.fromJson);

  Future<List<DriverOrder>> available() => _client.data<List<DriverOrder>>(
        HttpMethod.get,
        ApiEndpoints.driverOrdersAvailable,
        parse: (data) => ApiClient.parseList(data, DriverOrder.fromJson),
      );

  /// Null when the driver has no assigned order.
  Future<DriverOrder?> current() => _client.nullable<DriverOrder>(
        HttpMethod.get,
        ApiEndpoints.driverOrdersCurrent,
        parse: _parse,
      );

  Future<Paged<OrderSummary>> history({int? page, int? perPage}) =>
      _client.page<OrderSummary>(
        ApiEndpoints.driverOrdersHistory,
        item: OrderSummary.fromJson,
        query: {
          if (page != null) ApiQuery.page: page,
          if (perPage != null) ApiQuery.perPage: perPage,
        },
      );

  Future<DriverOrder> show(int id) => _client.data<DriverOrder>(
        HttpMethod.get,
        ApiEndpoints.driverOrder(id),
        parse: _parse,
      );

  Future<DriverOrder> accept(int id) => _client.data<DriverOrder>(
        HttpMethod.post,
        ApiEndpoints.driverOrderAccept(id),
        idempotent: true,
        parse: _parse,
      );

  Future<void> reject(int id) =>
      _client.command(HttpMethod.post, ApiEndpoints.driverOrderReject(id));

  Future<DriverOrder> transition(int id, TransitionRequest request) =>
      _client.data<DriverOrder>(
        HttpMethod.post,
        ApiEndpoints.driverOrderTransition(id),
        body: request.toJson(),
        idempotent: true,
        parse: _parse,
      );

  Future<DriverOrder> deliver(int id, DeliverRequest request) =>
      _client.data<DriverOrder>(
        HttpMethod.post,
        ApiEndpoints.driverOrderDeliver(id),
        body: request.toJson(),
        idempotent: true,
        parse: _parse,
      );
}
