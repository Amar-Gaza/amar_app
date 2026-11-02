import 'package:get/get.dart';

import '../../controllers/customer/address_form_controller.dart';
import '../../controllers/customer/cart_controller.dart';
import '../../controllers/customer/checkout_controller.dart';
import '../../controllers/customer/map_picker_controller.dart';
import '../../controllers/shared/app_config_controller.dart';
import '../../data/models/catalog/picked_location.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/address_service.dart';
import '../../data/services/customer/catalog_service.dart';
import '../../data/services/customer/order_service.dart';
import '../../data/services/shared/device_location_service.dart';
import '../../data/services/shared/upload_service.dart';

/// Applied by the cart tab, so every checkout step shares one instance
/// and it is disposed when the customer leaves the cart.
class CheckoutBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<CheckoutController>(
        () => CheckoutController(
          cart: Get.find<CartController>(),
          addresses: Get.find<AddressService>(),
          orders: Get.find<OrderService>(),
          uploads: Get.find<UploadService>(),
          catalog: Get.find<CatalogService>(),
          config: Get.find<AppConfigController>(),
        ),
      );
}

class MapPickerBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<MapPickerController>(
        () => MapPickerController(
          Get.find<DeviceLocationService>(),
          Get.arguments is PickedLocation
              ? Get.arguments as PickedLocation
              : null,
        ),
      );
}

class AddressFormBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<AddressFormController>(
        () => AddressFormController(
          Get.find<AddressService>(),
          Get.find<DeviceLocationService>(),
          existing: Get.arguments is Address ? Get.arguments as Address : null,
        ),
      );
}
