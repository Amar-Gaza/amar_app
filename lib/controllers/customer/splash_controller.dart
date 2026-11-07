import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../core/constants/api_query.dart';
import '../../core/constants/app_durations.dart';
import '../../core/network/api_failure.dart';
import '../shared/app_config_controller.dart';
import '../shared/push_controller.dart';
import '../driver/driver_session_controller.dart';
import '../shared/session_controller.dart';

class SplashController extends GetxController {
  SplashController(this._config, this._session, this._driver);

  final AppConfigController _config;
  final SessionController _session;
  final DriverSessionController _driver;

  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();

  /// True after a failed attempt; the retry shows the config checklist.
  final RxBool isRetrying = false.obs;

  @override
  void onReady() {
    super.onReady();
    start();
  }

  Future<void> start() async {
    isRetrying.value = failure.value != null;
    failure.value = null;
    final minimumDelay = Future<void>.delayed(AppDurations.splashMin);
    final loaded = await _config.load();
    await minimumDelay;
    if (!loaded) {
      failure.value = _config.error.value ??
          const ApiFailure(code: ApiErrorCodes.serverError);
      return;
    }
    if (await _driver.restore()) {
      unawaited(Get.offAllNamed<void>(AppRoutes.driverHome));
      await _openLaunchPush();
      return;
    }
    final hasSession = await _session.restore();
    unawaited(
      Get.offAllNamed<void>(hasSession ? AppRoutes.home : AppRoutes.onboarding),
    );
    if (hasSession) await _openLaunchPush();
  }

  /// A push tapped while the app was closed opens on top of home.
  Future<void> _openLaunchPush() async {
    if (!Get.isRegistered<PushController>()) return;
    // Let home build first so its bindings exist under the new screen.
    await WidgetsBinding.instance.endOfFrame;
    await Get.find<PushController>().openInitialMessage();
  }
}
