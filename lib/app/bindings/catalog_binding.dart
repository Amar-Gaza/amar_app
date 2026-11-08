import 'package:get/get.dart';

import '../../controllers/customer/cart_controller.dart';
import '../../controllers/customer/catalog_search_controller.dart';
import '../../controllers/customer/categories_controller.dart';
import '../../controllers/customer/product_controller.dart';
import '../../controllers/customer/products_controller.dart';
import '../../controllers/customer/vendor_details_controller.dart';
import '../../controllers/customer/vendors_controller.dart';
import '../../data/services/customer/catalog_service.dart';
import '../routes/route_args.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;

    Get.lazyPut<CatalogSearchController>(
      () => CatalogSearchController(
        Get.find<CatalogService>(),
        initialQuery: args is AiSearchArgs ? args.query : null,
        initialKind: args is AiSearchArgs ? args.kind : null,
      ),
    );
  }
}

class CategoriesBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<CategoriesController>(
        () => CategoriesController(
          Get.find<CatalogService>(),
        ),
      );
}

class VendorsBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<VendorsController>(
        () => VendorsController(
          Get.find<CatalogService>(),
          Get.arguments as VendorsArgs? ?? const VendorsArgs(),
        ),
      );
}

class VendorDetailsBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<VendorDetailsController>(
        () => VendorDetailsController(
          Get.find<CatalogService>(),
          Get.arguments as int,
        ),
      );
}

class ProductsBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<ProductsController>(
        () => ProductsController(
          Get.find<CatalogService>(),
          Get.arguments as ProductsArgs,
        ),
      );
}

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as ProductArgs;

    Get.put<ProductController>(
      ProductController(
        Get.find<CatalogService>(),
        Get.find<CartController>(),
        args.productId,
      ),
      tag: args.tag,
    );
  }
}
