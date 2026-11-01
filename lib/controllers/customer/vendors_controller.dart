import '../../app/routes/route_args.dart';
import '../../data/models/api/paged.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/catalog_service.dart';
import '../shared/paged_list_controller.dart';

class VendorsController extends PagedListController<Vendor> {
  VendorsController(this._service, this.args);

  final CatalogService _service;
  final VendorsArgs args;

  @override
  Future<Paged<Vendor>> fetch(int page, int perPage) => _service.vendors(
        category: args.category,
        page: page,
        perPage: perPage,
      );
}
