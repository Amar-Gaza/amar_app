import 'package:get/get.dart';

import '../../controllers/customer/notifications_controller.dart';
import '../../controllers/driver/driver_home_controller.dart';
import '../../controllers/driver/driver_location_controller.dart';
import '../../controllers/driver/driver_order_controller.dart';
import '../../controllers/driver/driver_orders_controller.dart';
import '../../controllers/driver/driver_profile_controller.dart';
import '../../controllers/driver/driver_session_controller.dart';
import '../../controllers/driver/driver_wallet_controller.dart';
import '../../core/localization/locale_controller.dart';
import '../../core/storage/secure_token_storage.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/driver/driver_location_service.dart';
import '../../data/services/driver/driver_order_service.dart';
import '../../data/services/driver/driver_profile_service.dart';
import '../../data/services/driver/driver_wallet_service.dart';
import '../../data/services/shared/device_location_service.dart';
import '../../data/services/shared/notification_service.dart';
import '../../data/services/shared/upload_service.dart';

/// Tag of driver-scoped controllers that share a class with the customer app.
const String driverTag = 'driver';

class DriverShellBinding extends Bindings {
  @override
  void dependencies() {
    final session = Get.find<DriverSessionController>();
    final location = Get.put<DriverLocationController>(
      DriverLocationController(
        Get.find<DeviceLocationService>(),
        Get.find<DriverLocationService>(),
        session,
      ),
      permanent: true,
    );
    Get
      ..lazyPut<DriverHomeController>(
        () => DriverHomeController(
          session,
          Get.find<DriverProfileService>(),
          Get.find<DriverOrderService>(),
          Get.find<DriverWalletService>(),
          location,
        ),
      )
      ..lazyPut<DriverOrdersController>(
        () => DriverOrdersController(Get.find<DriverOrderService>(), session),
      )
      ..lazyPut<DriverWalletController>(
        () => DriverWalletController(Get.find<DriverWalletService>()),
      );
  }
}

class DriverOrderBinding extends Bindings {
  @override
  void dependencies() {
    // An available offer comes as the list item (its details return 404
    // until accepted); an own order comes as its id.
    final arg = Get.arguments;
    Get.lazyPut<DriverOrderController>(
      () => DriverOrderController(
        Get.find<DriverOrderService>(),
        Get.find<UploadService>(),
        Get.find<DriverLocationController>(),
        Get.find<DriverSessionController>(),
        arg is DriverOrder ? arg.id : arg as int,
        initial: arg is DriverOrder ? arg : null,
      ),
    );
  }
}

class DriverProfileBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<DriverProfileController>(
        () => DriverProfileController(
          Get.find<DriverProfileService>(),
          Get.find<UploadService>(),
          Get.find<DriverSessionController>(),
          Get.find<LocaleController>(),
        ),
      );
}

class DriverNotificationsBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<NotificationsController>(
        () => NotificationsController(
          Get.find<NotificationService>(tag: SessionRole.driver.name),
        ),
        tag: driverTag,
      );
}
