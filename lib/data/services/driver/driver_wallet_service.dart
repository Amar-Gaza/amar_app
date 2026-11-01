import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/network/api_client.dart';
import '../../models/masar/masar_models.dart';

/// Cash on hand, settlements and earnings.
class DriverWalletService {
  DriverWalletService(this._client);

  final ApiClient _client;

  Future<Cash> cash() => _client.data<Cash>(
        HttpMethod.get,
        ApiEndpoints.driverCash,
        parse: (data) => ApiClient.parseObject(data, Cash.fromJson),
      );

  /// [period] is one of [EarningsPeriod].
  Future<Earnings> earnings({String period = EarningsPeriod.week}) =>
      _client.data<Earnings>(
        HttpMethod.get,
        ApiEndpoints.driverEarnings,
        query: {ApiQuery.period: period},
        parse: (data) => ApiClient.parseObject(data, Earnings.fromJson),
      );

  /// Sandbox projects only: settles the cash the driver holds.
  Future<Money> sandboxSettleCash() => _client.data<Money>(
        HttpMethod.post,
        ApiEndpoints.driverSettleCash,
        parse: (data) => Money.fromJson(
          Map<String, dynamic>.from((data! as Map)['cash_on_hand'] as Map),
        ),
      );
}
