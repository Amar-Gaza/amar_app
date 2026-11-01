import 'dart:async';

import 'package:get/get.dart';

import '../../core/constants/api_query.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/driver/driver_order_service.dart';
import '../../data/services/driver/driver_profile_service.dart';
import '../../data/services/driver/driver_wallet_service.dart';
import 'driver_location_controller.dart';
import 'driver_session_controller.dart';

enum DriverTab { home, orders, wallet, account }

/// Dashboard: availability, current task and today's summary (04, 05).
class DriverHomeController extends GetxController {
  DriverHomeController(
    this._session,
    this._profile,
    this._orders,
    this._wallet,
    this._location,
  );

  final DriverSessionController _session;
  final DriverProfileService _profile;
  final DriverOrderService _orders;
  final DriverWalletService _wallet;
  final DriverLocationController _location;

  final Rx<DriverTab> tab = DriverTab.home.obs;
  final Rxn<DriverOrder> current = Rxn<DriverOrder>();
  final Rxn<Earnings> today = Rxn<Earnings>();
  final RxBool isLoading = false.obs;
  final RxBool isToggling = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();

  Driver? get driver => _session.driver.value;
  bool get isOnline => driver?.isOnline ?? false;

  @override
  void onInit() {
    super.onInit();
    refreshAll();
  }

  Future<void> refreshAll() async {
    if (isLoading.value) return;
    isLoading.value = true;
    failure.value = null;
    try {
      final results = await Future.wait<Object?>([
        _profile.me(),
        _orders.current(),
        _wallet.earnings(period: EarningsPeriod.day),
      ]);
      _session.updateDriver(results[0]! as Driver);
      current.value = results[1] as DriverOrder?;
      today.value = results[2] as Earnings?;
      if (isOnline && !_location.isRunning) _location.start();
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  /// Going online needs a fresh location first (PUT /driver/status).
  Future<void> setOnline(bool online) async {
    if (isToggling.value) return;
    isToggling.value = true;
    failure.value = null;
    try {
      if (online && !await _location.sendNow()) return;
      final updated = await _profile.setOnline(online: online);
      _session.updateDriver(updated);
      online ? _location.start() : _location.stop();
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isToggling.value = false;
    }
  }
}
