
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../core/network/ai_gateway_client.dart';
import '../../data/services/shared/ai_speech_service.dart';

import '../../controllers/customer/ai_task_controller.dart';
import '../../controllers/customer/cart_controller.dart';
import '../../controllers/driver/driver_session_controller.dart';
import '../../controllers/shared/app_config_controller.dart';
import '../../controllers/shared/connectivity_controller.dart';
import '../../controllers/shared/session_controller.dart';
import '../../core/localization/locale_controller.dart';
import '../../core/network/api_client.dart';
import '../../core/network/session_events.dart';
import '../../core/storage/app_preferences.dart';
import '../../core/storage/secure_token_storage.dart';
import '../../data/services/customer/address_service.dart';
import '../../data/services/customer/app_config_service.dart';
import '../../data/services/customer/auth_service.dart';
import '../../data/services/customer/catalog_service.dart';
import '../../data/services/customer/order_service.dart';
import '../../data/services/customer/profile_service.dart';
import '../../data/services/driver/driver_auth_service.dart';
import '../../data/services/driver/driver_location_service.dart';
import '../../data/services/driver/driver_order_service.dart';
import '../../data/services/driver/driver_profile_service.dart';
import '../../data/services/driver/driver_wallet_service.dart';
import '../../data/services/shared/device_location_service.dart';
import '../../data/services/shared/notification_service.dart';
import '../../data/services/shared/upload_service.dart';

class InitialBinding extends Bindings {
  InitialBinding(this._prefs);

  final AppPreferences _prefs;

  @override
  void dependencies() {
    final tokens = SecureTokenStorage();
    final events = SessionEvents();

    final client = ApiClient(
      prefs: _prefs,
      tokens: tokens,
      events: events,
    );

    final auth = AuthService(client);
    final profile = ProfileService(client);

    Get.put<AiGatewayClient>(AiGatewayClient(tokens), permanent: true);
    Get.put<AiSpeechService>(AiSpeechService(), permanent: true);
    Get.put<AiTaskController>(AiTaskController(), permanent: true);

    Get.put<AppPreferences>(
      _prefs,
      permanent: true,
    );

    Get.put<ApiClient>(
      client,
      permanent: true,
    );

    Get.put<AuthService>(
      auth,
      permanent: true,
    );

    Get.put<ProfileService>(
      profile,
      permanent: true,
    );

    Get.put<CatalogService>(
      CatalogService(client),
      permanent: true,
    );

    Get.put<AddressService>(
      AddressService(client),
      permanent: true,
    );

    Get.put<OrderService>(
      OrderService(client),
      permanent: true,
    );

    Get.put<UploadService>(
      UploadService(client),
      permanent: true,
    );

    Get.put<DeviceLocationService>(
      DeviceLocationService(
        preferences: _prefs,
      ),
      permanent: true,
    );

    Get.put<NotificationService>(
      NotificationService.customer(client),
      permanent: true,
    );

    Get.put<NotificationService>(
      NotificationService.driver(client),
      tag: SessionRole.driver.name,
      permanent: true,
    );

    Get.put<DriverAuthService>(
      DriverAuthService(client),
      permanent: true,
    );

    Get.put<DriverProfileService>(
      DriverProfileService(client),
      permanent: true,
    );

    Get.put<DriverOrderService>(
      DriverOrderService(client),
      permanent: true,
    );

    Get.put<DriverLocationService>(
      DriverLocationService(client),
      permanent: true,
    );

    Get.put<DriverWalletService>(
      DriverWalletService(client),
      permanent: true,
    );

    Get.put<LocaleController>(
      LocaleController(
        _prefs,
        Get.find<DeviceLocationService>(),
      ),
      permanent: true,
    );

    Get.put<CartController>(
      CartController(
        preferences: _prefs,
      ),
      permanent: true,
    );

    Get.put<ConnectivityController>(
      ConnectivityController(
        Connectivity(),
      ),
      permanent: true,
    );

    Get.put<AppConfigController>(
      AppConfigController(
        AppConfigService(client),
        _prefs,
      ),
      permanent: true,
    );

    Get.put<SessionController>(
      SessionController(
        tokens,
        auth,
        profile,
        events,
        preferences: _prefs,
        cart: Get.find<CartController>(),
        location: Get.find<DeviceLocationService>(),
      ),
      permanent: true,
    );

    Get.put<DriverSessionController>(
      DriverSessionController(
        tokens,
        Get.find<DriverAuthService>(),
        Get.find<DriverProfileService>(),
        AppConfigService(client),
        events,
      ),
      permanent: true,
    );
  }
}
