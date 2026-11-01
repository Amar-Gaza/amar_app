import 'package:get/get.dart';

import '../../app/routes/route_args.dart';
import '../../data/models/api/paged.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/catalog_service.dart';
import '../shared/paged_list_controller.dart';

/// Products of a category or a vendor, with an in-list search.
class ProductsController extends PagedListController<Product> {
  ProductsController(this._service, this.args);

  final CatalogService _service;
  final ProductsArgs args;
  final RxString query = ''.obs;

  @override
  Future<Paged<Product>> fetch(int page, int perPage) => _service.products(
        categoryId: args.categoryId,
        vendorId: args.vendorId,
        search: query.value.trim(),
        page: page,
        perPage: perPage,
      );

  Future<void> search(String value) async {
    query.value = value;
    await load();
  }
}
