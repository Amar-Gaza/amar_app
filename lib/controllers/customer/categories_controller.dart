import 'package:get/get.dart';

import '../../core/network/api_failure.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/catalog_service.dart';

class CategoriesController extends GetxController {
  CategoriesController(this._service);

  final CatalogService _service;
  final RxList<Category> all = <Category>[].obs;
  final RxString filter = ''.obs;
  final RxBool isLoading = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();

  List<Category> get visible {
    final term = filter.value.trim();
    if (term.isEmpty) return all;
    return all.where((c) => c.name.contains(term)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    if (isLoading.value) return;
    isLoading.value = true;
    failure.value = null;
    try {
      all.assignAll(await _service.categories());
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isLoading.value = false;
    }
  }
}
