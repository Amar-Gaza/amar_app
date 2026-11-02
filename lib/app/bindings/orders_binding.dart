import 'package:get/get.dart';

import '../../controllers/customer/order_actions_controller.dart';
import '../../controllers/customer/order_details_controller.dart';
import '../../controllers/customer/public_tracking_controller.dart';
import '../../controllers/customer/tracking_controller.dart';
import '../../controllers/shared/app_config_controller.dart';
import '../../data/services/customer/order_service.dart';
import '../../data/services/shared/upload_service.dart';

/// Order screens receive the order id as [Get.arguments].
class OrderDetailsBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<OrderDetailsController>(
        () => OrderDetailsController(
          Get.find<OrderService>(),
          Get.find<AppConfigController>(),
          Get.find<UploadService>(),
          Get.arguments as int,
        ),
      );
}

class OrderActionsBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<OrderActionsController>(
        () => OrderActionsController(
          Get.find<OrderService>(),
          Get.arguments as int,
        ),
      );
}

class TrackingBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<TrackingController>(
        () => TrackingController(
          Get.find<OrderService>(),
          Get.find<AppConfigController>(),
          Get.arguments as int,
        ),
      );
}

/// Optional token argument; without it the screen asks for a link.
class PublicTrackingBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<PublicTrackingController>(
        () => PublicTrackingController(
          Get.find<OrderService>(),
          token: Get.arguments as String?,
        ),
      );
}
