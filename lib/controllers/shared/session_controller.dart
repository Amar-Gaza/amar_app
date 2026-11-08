import 'dart:async';

import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../core/constants/api_query.dart';
import '../../core/network/api_failure.dart';
import '../../core/network/session_events.dart';
import '../../core/storage/secure_token_storage.dart';
import '../../core/storage/app_preferences.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/auth_service.dart';
import '../../data/services/customer/profile_service.dart';
import '../../data/services/shared/device_location_service.dart';
import '../customer/cart_controller.dart';

class SessionController extends GetxController {
  SessionController(
    this._tokens,
    this._auth,
    this._profile,
    this._events, {
    AppPreferences? preferences,
    CartController? cart,
    DeviceLocationService? location,
  })  : _preferences = preferences,
        _cart = cart,
        _location = location;

  final SecureTokenStorage _tokens;
  final AuthService _auth;
  final ProfileService _profile;
  final SessionEvents _events;

  final AppPreferences? _preferences;
  final CartController? _cart;
  final DeviceLocationService? _location;

  final Rxn<User> user = Rxn<User>();
  final RxBool isAuthenticated = false.obs;

  StreamSubscription<SessionRole>? _subscription;

  Future<void> _activateLocalCustomer(
    int? customerId,
  ) async {
    // Swap both caches before any await.
    // Location switching also invalidates old requests.
    _location?.activateCustomer(customerId);
    _cart?.activateCustomer(customerId);

    await _preferences?.setActiveCustomerId(customerId);
  }

  @override
  void onInit() {
    super.onInit();

    _subscription = _events.unauthorized.listen(
      _onUnauthorized,
    );
  }

  /// Restores a stored customer session.
  Future<bool> restore() async {
    final token = await _tokens.read(
      SessionRole.customer,
    );

    if (token == null || token.isEmpty) {
      await _activateLocalCustomer(null);
      return false;
    }

    try {
      user.value = await _profile.me();

      await _activateLocalCustomer(user.value!.id);

      isAuthenticated.value = true;

      return true;
    } on ApiFailure catch (failure) {
      // Transient failures keep the stored session.
      // A 401 clears it through session events.
      final keep = failure.code != ApiErrorCodes.unauthenticated;

      isAuthenticated.value = keep;

      return keep;
    }
  }

  Future<void> start(
    String token,
    User signedIn,
  ) async {
    await _tokens.write(
      SessionRole.customer,
      token,
    );

    await _activateLocalCustomer(signedIn.id);

    user.value = signedIn;
    isAuthenticated.value = true;
  }

  void updateUser(User updated) {
    user.value = updated;
  }

  Future<void> signOut() async {
    try {
      await _auth.logout();
    } on ApiFailure {
      // Clear the local session regardless
      // of the server result.
    }

    await _clear();

    Get.offAllNamed<void>(AppRoutes.phone);
  }

  Future<void> deleteAccount() async {
    final customerId = user.value?.id ?? _preferences?.activeCustomerId;

    await _profile.deleteAccount();

    await _clear();

    if (customerId != null) {
      await _preferences?.deleteCustomerState(customerId);
    }

    await Get.offAllNamed<void>(AppRoutes.phone);
  }

  Future<void> _onUnauthorized(
    SessionRole role,
  ) async {
    if (role != SessionRole.customer) return;

    await _clear();

    Get.offAllNamed<void>(AppRoutes.phone);
  }

  Future<void> _clear() async {
    await _tokens.clear(SessionRole.customer);

    await _activateLocalCustomer(null);

    user.value = null;
    isAuthenticated.value = false;
  }

  @override
  void onClose() {
    unawaited(_subscription?.cancel());

    super.onClose();
  }
}
