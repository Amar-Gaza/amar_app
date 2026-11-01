import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/models/api/paged.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/catalog_service.dart';
import '../shared/paged_list_controller.dart';

/// Product search (GET /products?q=). Nothing is fetched until a query.
class CatalogSearchController extends PagedListController<Product> {
  CatalogSearchController(this._service);

  final CatalogService _service;
  final TextEditingController input = TextEditingController();
  final RxString query = ''.obs;

  bool get hasQuery => query.value.trim().isNotEmpty;

  @override
  bool get loadOnInit => false;

  @override
  Future<Paged<Product>> fetch(int page, int perPage) => _service.products(
        search: query.value.trim(),
        page: page,
        perPage: perPage,
      );

  Future<void> submit([String? value]) async {
    query.value = value ?? input.text;
    if (!hasQuery) {
      items.clear();
      return;
    }
    await load();
  }

  void clearQuery() {
    input.clear();
    query.value = '';
    items.clear();
    failure.value = null;
  }

  @override
  void onClose() {
    input.dispose();
    super.onClose();
  }
}
