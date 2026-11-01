import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

/// Device-level connectivity signal used for the offline banner.
class ConnectivityController extends GetxController {
  ConnectivityController(this._connectivity);

  final Connectivity _connectivity;
  final RxBool isOffline = false.obs;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    unawaited(_connectivity.checkConnectivity().then(_update));
    _subscription = _connectivity.onConnectivityChanged.listen(_update);
  }

  void _update(List<ConnectivityResult> results) => isOffline.value =
      results.every((result) => result == ConnectivityResult.none);

  @override
  void onClose() {
    unawaited(_subscription?.cancel());
    super.onClose();
  }
}
