import 'package:get/get.dart';

import '../../core/constants/app_defaults.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/api/paged.dart';

/// Shared first-page / next-page / retry logic for paginated lists.
abstract class PagedListController<T> extends GetxController {
  final RxList<T> items = <T>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = false.obs;
  final RxInt total = 0.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  int _page = 1;

  Future<Paged<T>> fetch(int page, int perPage);

  /// Lists that wait for user input (search) turn this off.
  bool get loadOnInit => true;

  @override
  void onInit() {
    super.onInit();
    if (loadOnInit) load();
  }

  Future<void> load() async {
    if (isLoading.value) return;
    isLoading.value = true;
    failure.value = null;
    try {
      final page = await fetch(1, AppDefaults.pageSize);
      _apply(page);
      items.assignAll(page.items);
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value || !hasMore.value) return;
    isLoadingMore.value = true;
    try {
      final page = await fetch(_page + 1, AppDefaults.pageSize);
      _apply(page);
      items.addAll(page.items);
    } on ApiFailure {
      // The loaded items stay; the next scroll retries.
    } finally {
      isLoadingMore.value = false;
    }
  }

  void _apply(Paged<T> page) {
    _page = page.page;
    hasMore.value = page.hasMore;
    total.value = page.total;
  }
}
