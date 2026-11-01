import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/network/api_failure.dart';
import '../../core/storage/app_preferences.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/app_config_service.dart';

class AppConfigController extends GetxController with WidgetsBindingObserver {
  AppConfigController(this._service, this._prefs);

  static const String _configSecondsKey = 'config_seconds';

  final AppConfigService _service;
  final AppPreferences _prefs;

  final Rxn<AppConfig> config = Rxn<AppConfig>();

  /// Polling interval from `polling.<key>` (seconds), with a fallback.
  Duration poll(String key, int fallbackSeconds) {
    final value = config.value?.polling[key];
    return Duration(
      seconds: value is num && value > 0 ? value.toInt() : fallbackSeconds,
    );
  }

  /// Highest non-terminal status step, for progress bars.
  int get lastStep {
    final steps =
        config.value?.statuses.where((s) => !s.isTerminal).map((s) => s.step) ??
            const <int>[];
    return steps.isEmpty ? 1 : steps.reduce((a, b) => a > b ? a : b);
  }

  final Rxn<ApiFailure> error = Rxn<ApiFailure>();
  final RxBool isLoading = false.obs;
  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    final cached = _prefs.cachedConfig;
    if (cached != null) config.value = AppConfig.fromJson(cached);
  }

  Future<bool> load() async {
    if (isLoading.value) return config.value != null;
    isLoading.value = true;
    error.value = null;
    try {
      final fresh = await _service.fetch();
      if (fresh != null) {
        config.value = fresh;
        await _prefs.saveConfig(fresh.configVersion, fresh.toJson());
      }
      _scheduleRefresh();
      return config.value != null;
    } on ApiFailure catch (failure) {
      error.value = failure;
      return config.value != null;
    } finally {
      isLoading.value = false;
    }
  }

  void _scheduleRefresh() {
    _refreshTimer?.cancel();
    final seconds = config.value?.polling[_configSecondsKey];
    if (seconds is! num || seconds <= 0) return;
    _refreshTimer = Timer.periodic(
      Duration(seconds: seconds.toInt()),
      (_) => load(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (config.value != null) {
        _scheduleRefresh();
        unawaited(load());
      }
    } else {
      _refreshTimer?.cancel();
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.onClose();
  }
}
