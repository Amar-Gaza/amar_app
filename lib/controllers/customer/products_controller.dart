import 'package:get/get.dart';

import '../../app/routes/route_args.dart';
import '../../data/models/api/paged.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/catalog_service.dart';
import '../shared/paged_list_controller.dart';

/// Products and services of a category or a vendor, with an in-list search.
class ProductsController extends PagedListController<Product> {
  ProductsController(this._service, this.args);

  final CatalogService _service;
  final ProductsArgs args;
  final RxString query = ''.obs;

  @override
  Future<Paged<Product>> fetch(int page, int perPage) async {
    final ids = args.categoryIds;
    if (ids.length <= 1) {
      return _page(ids.firstOrNull, page, perPage);
    }
    // A unified category spans several server ids: merge their same page.
    final pages = await Future.wait(
      ids.map((id) => _page(id, page, perPage)),
    );
    return Paged<Product>(
      items: [for (final part in pages) ...part.items],
      page: page,
      lastPage: pages.map((p) => p.lastPage).reduce((a, b) => a > b ? a : b),
      total: pages.fold(0, (sum, p) => sum + p.total),
    );
  }

  Future<Paged<Product>> _page(int? categoryId, int page, int perPage) =>
      _service.products(
        categoryId: categoryId,
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
