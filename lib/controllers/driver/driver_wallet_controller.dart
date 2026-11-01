import 'package:get/get.dart';

import '../../core/constants/api_query.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/driver/driver_wallet_service.dart';

/// Cash on hand, limit, settlements and earnings (designs 26–30).
class DriverWalletController extends GetxController {
  DriverWalletController(this._wallet);

  final DriverWalletService _wallet;

  final Rxn<Cash> cash = Rxn<Cash>();
  final Rxn<Earnings> earnings = Rxn<Earnings>();
  final RxString period = EarningsPeriod.week.obs;
  final RxBool isLoading = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    if (isLoading.value) return;
    isLoading.value = true;
    failure.value = null;
    try {
      final results = await Future.wait<Object>([
        _wallet.cash(),
        _wallet.earnings(period: period.value),
      ]);
      cash.value = results[0] as Cash;
      earnings.value = results[1] as Earnings;
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectPeriod(String value) async {
    period.value = value;
    try {
      earnings.value = await _wallet.earnings(period: value);
    } on ApiFailure catch (e) {
      failure.value = e;
    }
  }
}
