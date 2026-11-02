import 'package:get/get.dart';

import '../../controllers/customer/auth_controller.dart';
import '../../controllers/customer/catalog_controller.dart';
import '../../controllers/customer/notifications_controller.dart';
import '../../controllers/customer/orders_controller.dart';
import '../../controllers/customer/profile_setup_controller.dart';
import '../../controllers/customer/shell_controller.dart';
import '../../controllers/customer/splash_controller.dart';
import '../../controllers/driver/driver_session_controller.dart';
import '../../controllers/shared/app_config_controller.dart';
import '../../controllers/shared/session_controller.dart';
import '../../core/localization/locale_controller.dart';
import '../../data/services/customer/address_service.dart';
import '../../data/services/customer/auth_service.dart';
import '../../data/services/customer/catalog_service.dart';
import '../../data/services/customer/order_service.dart';
import '../../data/services/shared/notification_service.dart';
import '../../data/services/customer/profile_service.dart';
import '../../data/services/shared/upload_service.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(
        Get.find<AppConfigController>(),
        Get.find<SessionController>(),
        Get.find<DriverSessionController>(),
      ),
    );
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(
        Get.find<AuthService>(),
        Get.find<SessionController>(),
      ),
    );
  }
}

class ProfileSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSetupController>(
      () => ProfileSetupController(
        Get.find<ProfileService>(),
        Get.find<UploadService>(),
        Get.find<SessionController>(),
        Get.find<LocaleController>(),
      ),
    );
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<ShellController>(ShellController.new)
      ..lazyPut<CatalogController>(
        () => CatalogController(
          Get.find<CatalogService>(),
          Get.find<OrderService>(),
          Get.find<AddressService>(),
        ),
      )
      ..lazyPut<OrdersController>(
        () => OrdersController(Get.find<OrderService>()),
      )
      ..lazyPut<NotificationsController>(
        () => NotificationsController(Get.find<NotificationService>()),
      );
  }
}
