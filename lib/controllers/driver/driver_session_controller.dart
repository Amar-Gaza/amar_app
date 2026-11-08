import 'dart:async';

import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../core/constants/api_query.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/network/api_failure.dart';
import '../../core/network/session_events.dart';
import '../../core/storage/secure_token_storage.dart';
import '../../core/utils/validators.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/app_config_service.dart';
import '../../data/services/driver/driver_auth_service.dart';
import '../../data/services/driver/driver_profile_service.dart';
import '../shared/push_controller.dart';

/// Driver session, fully separate from the customer one (designs 01–03).
class DriverSessionController extends GetxController {
  DriverSessionController(
    this._tokens,
    this._auth,
    this._profile,
    this._configService,
    this._events, {
    PushController? push,
  }) : _push = push;

  final SecureTokenStorage _tokens;
  final DriverAuthService _auth;
  final DriverProfileService _profile;
  final AppConfigService _configService;
  final SessionEvents _events;
  final PushController? _push;

  final Rxn<Driver> driver = Rxn<Driver>();
  final Rxn<AppConfig> config = Rxn<AppConfig>();
  final RxBool isSubmitting = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  StreamSubscription<SessionRole>? _subscription;

  bool get isSignedIn => driver.value != null;

  @override
  void onInit() {
    super.onInit();
    _subscription = _events.unauthorized.listen((role) {
      if (role == SessionRole.driver) _expire();
    });
  }

  Future<void> loadConfig() async {
    try {
      final fresh = await _configService.fetch(app: ApiQuery.appDriver);
      if (fresh != null) config.value = fresh;
    } on ApiFailure {
      // The driver app works with defaults until the next attempt.
    }
  }

  /// Restores a stored driver token (design 02). True when valid.
  Future<bool> restore() async {
    final token = await _tokens.read(SessionRole.driver);
    if (token == null || token.isEmpty) return false;
    try {
      driver.value = await _profile.me();
      unawaited(loadConfig());
      unawaited(_push?.register(SessionRole.driver));
      return true;
    } on ApiFailure catch (e) {
      final keep = e.code != ApiErrorCodes.unauthenticated && e.isConnectivity;
      if (keep) unawaited(_push?.register(SessionRole.driver));
      return keep;
    }
  }

  Future<bool> login(String phone, String password) async {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    failure.value = null;
    try {
      final result = await _auth.login(
        phone: Validators.localPhone(phone),
        password: password,
        deviceName: AppDefaults.deviceName,
      );
      await _tokens.write(SessionRole.driver, result.token);
      driver.value = result.driver;
      await loadConfig();
      unawaited(_push?.register(SessionRole.driver));
      return true;
    } on ApiFailure catch (e) {
      failure.value = e;
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  void updateDriver(Driver value) => driver.value = value;

  Future<void> logout() async {
    // Before logout, while the token still authenticates.
    await _push?.unregister(SessionRole.driver);
    try {
      await _auth.logout();
    } on ApiFailure {
      // The local session is cleared regardless.
    }
    await _clear();
    await Get.offAllNamed<void>(AppRoutes.driverLogin);
  }

  Future<void> _expire() async {
    await _clear();
    await Get.offAllNamed<void>(AppRoutes.driverLogin);
  }

  Future<void> _clear() async {
    _push?.forget(SessionRole.driver);
    await _tokens.clear(SessionRole.driver);
    driver.value = null;
  }

  @override
  void onClose() {
    unawaited(_subscription?.cancel());
    super.onClose();
  }
}
