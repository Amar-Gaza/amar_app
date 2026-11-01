import 'dart:async';

import 'package:get/get.dart';

import '../../core/constants/api_query.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/order_service.dart';
import '../shared/app_config_controller.dart';

/// Live tracking (designs 12, 13, 17A–C), polled at the server's pace.
class TrackingController extends GetxController {
  TrackingController(this._orders, this._config, this.orderId);

  final OrderService _orders;
  final AppConfigController _config;
  final int orderId;

  final Rxn<Tracking> tracking = Rxn<Tracking>();
  final RxBool isLoading = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  final RxInt nextPoll = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    refreshNow();
  }

  Future<void> refreshNow() async {
    _timer?.cancel();
    isLoading.value = tracking.value == null;
    failure.value = null;
    try {
      tracking.value = await _orders.tracking(orderId);
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isLoading.value = false;
    }
    if (tracking.value?.status.isTerminal ?? false) return;
    final fallback = _config
        .poll(PollKeys.tracking, AppDefaults.pollFallbackSeconds)
        .inSeconds;
    final seconds = tracking.value?.nextPollSeconds ?? fallback;
    nextPoll.value = seconds > 0 ? seconds : fallback;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (nextPoll.value <= 1) {
        refreshNow();
      } else {
        nextPoll.value--;
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
