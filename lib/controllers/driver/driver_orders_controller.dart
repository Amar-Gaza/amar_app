import 'dart:async';

import 'package:get/get.dart';

import '../../core/constants/api_query.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/driver/driver_order_service.dart';
import 'driver_session_controller.dart';

enum DriverOrdersView { available, history }

/// Available jobs (polled) and finished history (designs 08, 09).
class DriverOrdersController extends GetxController {
  DriverOrdersController(this._orders, this._session);

  final DriverOrderService _orders;
  final DriverSessionController _session;

  final Rx<DriverOrdersView> view = DriverOrdersView.available.obs;
  final RxList<DriverOrder> available = <DriverOrder>[].obs;
  final RxList<OrderSummary> history = <OrderSummary>[].obs;
  final RxBool isLoading = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  Timer? _poll;

  @override
  void onInit() {
    super.onInit();
    load();
    final seconds = _session.config.value?.polling[PollKeys.availableOrders];
    _poll = Timer.periodic(
      Duration(
        seconds: seconds is num && seconds > 0
            ? seconds.toInt()
            : AppDefaults.pollFallbackSeconds,
      ),
      (_) {
        if (view.value == DriverOrdersView.available) {
          _loadAvailable(silent: true);
        }
      },
    );
  }

  Future<void> select(DriverOrdersView value) async {
    view.value = value;
    await load();
  }

  /// History without switching [view], so available offers keep polling.
  Future<void> loadHistory() => _loadHistory();

  Future<void> load() => view.value == DriverOrdersView.available
      ? _loadAvailable()
      : _loadHistory();

  Future<void> _loadAvailable({bool silent = false}) async {
    if (!silent) isLoading.value = true;
    failure.value = null;
    try {
      available.assignAll(await _orders.available());
    } on ApiFailure catch (e) {
      if (!silent) failure.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadHistory() async {
    isLoading.value = true;
    failure.value = null;
    try {
      history.assignAll(
        (await _orders.history(perPage: AppDefaults.pageSize)).items,
      );
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _poll?.cancel();
    super.onClose();
  }
}
