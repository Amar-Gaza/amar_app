import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/bindings/driver_binding.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/push_keys.dart';
import '../../core/storage/secure_token_storage.dart';
import '../../core/utils/app_logger.dart';
import '../../data/services/customer/profile_service.dart';
import '../../data/services/driver/driver_profile_service.dart';
import '../../data/services/shared/notification_service.dart';
import '../../l10n/app_localizations.dart';
import '../customer/notifications_controller.dart';
import '../customer/order_details_controller.dart';
import '../customer/orders_controller.dart';
import '../customer/tracking_controller.dart';
import '../driver/driver_home_controller.dart';
import '../driver/driver_order_controller.dart';
import '../driver/driver_orders_controller.dart';

/// Runs in its own isolate when a push arrives while the app is in the
/// background or closed. The system shows the notification by itself.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

/// Firebase Cloud Messaging for both apps: saves the device token for the
/// signed-in role, reacts to pushes and opens the right screen on tap.
class PushController extends GetxService {
  PushController({
    required ProfileService profile,
    required DriverProfileService driverProfile,
    required NotificationService customerInbox,
    required NotificationService driverInbox,
  })  : _profile = profile,
        _driverProfile = driverProfile,
        _customerInbox = customerInbox,
        _driverInbox = driverInbox;

  final ProfileService _profile;
  final DriverProfileService _driverProfile;
  final NotificationService _customerInbox;
  final NotificationService _driverInbox;

  static bool _available = false;

  /// The role whose token is on this device; null when signed out.
  SessionRole? _role;
  Future<RemoteMessage?>? _initial;
  final List<StreamSubscription<Object?>> _subscriptions = [];

  /// Call once in main before runApp. Push stays off when Firebase is
  /// not configured (no google-services.json), and the app works as before.
  static Future<void> bootstrap() async {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
      _available = true;
    } on Object catch (e) {
      AppLogger.d('Push disabled: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (!_available) return;
    _initial = FirebaseMessaging.instance.getInitialMessage();
    _subscriptions.addAll([
      // Masar sends to the FCM registration token, not the installation ID
      // that register()/onRegistered return, so the token API stays.
      // ignore: deprecated_member_use
      FirebaseMessaging.instance.onTokenRefresh.listen(_onTokenRefresh),
      FirebaseMessaging.onMessage.listen(_onForeground),
      FirebaseMessaging.onMessageOpenedApp.listen(_open),
    ]);
  }

  /// After sign-in or a restored session: asks for permission and saves
  /// this device's token for [role].
  Future<void> register(SessionRole role) async {
    _role = role;
    if (!_available) return;
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      // The FCM registration token Masar expects (see onTokenRefresh).
      // ignore: deprecated_member_use
      final token = await messaging.getToken();
      if (token != null && _role == role) await _save(role, token);
    } on Object catch (e) {
      AppLogger.d('Push token not saved: $e');
    }
  }

  /// Before sign-out, while the session token still works: stops pushes
  /// for [role] on this device.
  Future<void> unregister(SessionRole role) async {
    try {
      await _save(role, null);
    } on Object catch (e) {
      AppLogger.d('Push token not removed: $e');
    }
  }

  /// The local session for [role] is gone.
  void forget(SessionRole role) {
    if (_role == role) _role = null;
  }

  /// Opens the push that launched the app from closed. Call once the
  /// first screen after splash is shown.
  Future<void> openInitialMessage() async {
    final pending = _initial;
    _initial = null;
    final message = await pending;
    if (message != null) await _open(message);
  }

  /// Opens the screen a notification points to: the order when it has
  /// one, else the inbox (unless [fromInbox]).
  void openTarget(
    SessionRole role,
    Map<String, dynamic> data, {
    bool fromInbox = false,
  }) {
    final orderId = _int(data[PushKeys.orderId]);
    if (role == SessionRole.customer) {
      if (orderId != null) {
        unawaited(Get.toNamed<void>(AppRoutes.order, arguments: orderId));
      } else if (!fromInbox) {
        unawaited(Get.toNamed<void>(AppRoutes.notifications));
      }
      return;
    }
    if (data[PushKeys.type] == PushKeys.orderAvailable) {
      // An available order has no details until accepted: show the list.
      Get.until((route) => route.isFirst);
      _showDriverAvailable();
    } else if (orderId != null) {
      unawaited(Get.toNamed<void>(AppRoutes.driverOrder, arguments: orderId));
    } else if (!fromInbox) {
      unawaited(Get.toNamed<void>(AppRoutes.driverNotifications));
    }
  }

  Future<bool> _save(SessionRole role, String? token) =>
      role == SessionRole.driver
          ? _driverProfile.updateFcmToken(token)
          : _profile.updateFcmToken(token);

  void _onTokenRefresh(String token) {
    final role = _role;
    if (role == null) return;
    unawaited(
      _save(role, token).then<void>(
        (_) {},
        onError: (Object e) => AppLogger.d('Push token not saved: $e'),
      ),
    );
  }

  void _onForeground(RemoteMessage message) {
    final role = _role;
    if (role == null) return;
    _refresh(role, message.data);

    final title = message.notification?.title;
    final body = message.notification?.body;
    final context = Get.context;
    if (context == null || (title == null && body == null)) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: AppDurations.pushBanner,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              if (body != null) Text(body),
            ],
          ),
          action: SnackBarAction(
            label: AppLocalizations.of(context).pushView,
            onPressed: () => unawaited(_open(message)),
          ),
        ),
      );
  }

  Future<void> _open(RemoteMessage message) async {
    final role = _role;
    if (role == null) return;
    openTarget(role, message.data);
    final id = _int(message.data[PushKeys.notificationId]);
    if (id != null) await _markOpened(role, id);
    _refresh(role, message.data);
  }

  Future<void> _markOpened(SessionRole role, int id) async {
    try {
      await (role == SessionRole.driver ? _driverInbox : _customerInbox)
          .markOpened(id);
    } on Object catch (e) {
      AppLogger.d('Push open not reported: $e');
    }
  }

  /// Reloads whatever on screen the push may have changed.
  void _refresh(SessionRole role, Map<String, dynamic> data) {
    final orderId = _int(data[PushKeys.orderId]);
    unawaited(_inboxController(role)?.load());
    if (role == SessionRole.customer) {
      if (Get.isRegistered<OrdersController>()) {
        unawaited(Get.find<OrdersController>().load());
      }
      if (Get.isRegistered<OrderDetailsController>()) {
        final details = Get.find<OrderDetailsController>();
        if (details.orderId == orderId) unawaited(details.load());
      }
      if (Get.isRegistered<TrackingController>()) {
        final tracking = Get.find<TrackingController>();
        if (tracking.orderId == orderId) unawaited(tracking.refreshNow());
      }
      return;
    }
    if (Get.isRegistered<DriverHomeController>()) {
      unawaited(Get.find<DriverHomeController>().refreshAll());
    }
    if (Get.isRegistered<DriverOrdersController>()) {
      unawaited(Get.find<DriverOrdersController>().load());
    }
    if (Get.isRegistered<DriverOrderController>()) {
      final order = Get.find<DriverOrderController>();
      if (order.orderId == orderId) unawaited(order.load());
    }
  }

  void _showDriverAvailable() {
    if (Get.isRegistered<DriverHomeController>()) {
      Get.find<DriverHomeController>().tab.value = DriverTab.orders;
    }
    if (Get.isRegistered<DriverOrdersController>()) {
      unawaited(
        Get.find<DriverOrdersController>().select(DriverOrdersView.available),
      );
    }
  }

  NotificationsController? _inboxController(SessionRole role) {
    final tag = role == SessionRole.driver ? driverTag : null;
    return Get.isRegistered<NotificationsController>(tag: tag)
        ? Get.find<NotificationsController>(tag: tag)
        : null;
  }

  static int? _int(Object? value) =>
      value == null ? null : int.tryParse(value.toString());

  @override
  void onClose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    super.onClose();
  }
}
