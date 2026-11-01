import 'package:get/get.dart';

import '../../controllers/customer/addresses_controller.dart';
import '../../controllers/customer/edit_profile_controller.dart';
import '../../controllers/customer/vendor_application_controller.dart';
import '../../controllers/shared/session_controller.dart';
import '../../core/localization/locale_controller.dart';
import '../../data/services/customer/address_service.dart';
import '../../data/services/customer/catalog_service.dart';
import '../../data/services/customer/profile_service.dart';
import '../../data/services/shared/device_location_service.dart';
import '../../data/services/shared/upload_service.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<EditProfileController>(
        () => EditProfileController(
          Get.find<ProfileService>(),
          Get.find<UploadService>(),
          Get.find<SessionController>(),
          Get.find<LocaleController>(),
        ),
      );
}

class AddressesBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<AddressesController>(
        () => AddressesController(Get.find<AddressService>()),
      );
}

class VendorApplicationBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<VendorApplicationController>(
        () => VendorApplicationController(
          Get.find<CatalogService>(),
          Get.find<DeviceLocationService>(),
        ),
      );
}
