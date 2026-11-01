import 'dart:async';

import 'package:get/get.dart';

import '../../core/constants/api_query.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/order_service.dart';
import '../shared/app_config_controller.dart';

/// Order page (designs 05 and 06). Polls events while the order is open
/// and reloads it when anything happens.
class OrderDetailsController extends GetxController {
  OrderDetailsController(this._orders, this._config, this.orderId);

  final OrderService _orders;
  final AppConfigController _config;
  final int orderId;

  final Rxn<Order> order = Rxn<Order>();
  final RxBool isLoading = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  Timer? _poll;
  String? _lastEvent;

  int get lastStep => _config.lastStep;

  bool can(String action) =>
      order.value?.availableActions.any((a) => a.action == action) ?? false;

  OrderAction? action(String action) =>
      order.value?.availableActions.firstWhereOrNull((a) => a.action == action);

  bool get hasOffer => order.value?.status.key == AppDefaults.pricedStatus;

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
      order.value = await _orders.show(orderId);
      _schedule();
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  void _schedule() {
    _poll?.cancel();
    if (order.value?.status.isTerminal ?? true) return;
    _poll = Timer.periodic(
      _config.poll(PollKeys.events, AppDefaults.pollFallbackSeconds),
      (_) => _checkEvents(),
    );
  }

  Future<void> _checkEvents() async {
    try {
      final events = await _orders.events(orderId, since: _lastEvent);
      if (events.isEmpty) return;
      _lastEvent = '${events.last.id}';
      order.value = await _orders.show(orderId);
      if (order.value?.status.isTerminal ?? false) _poll?.cancel();
    } on ApiFailure {
      // Polling is best-effort; the next tick retries.
    }
  }

  @override
  void onClose() {
    _poll?.cancel();
    super.onClose();
  }
}
