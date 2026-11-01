import 'package:get/get.dart';

import '../../core/constants/api_query.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/order_service.dart';

/// Orders tab: one list per scope, paged.
class OrdersController extends GetxController {
  OrdersController(this._orders);

  static const List<String> scopes = [
    OrderScope.active,
    OrderScope.completed,
    OrderScope.cancelled,
  ];

  final OrderService _orders;

  final RxString scope = OrderScope.active.obs;
  final RxList<OrderSummary> items = <OrderSummary>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  int _page = 1;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> selectScope(String value) async {
    if (scope.value == value) return;
    scope.value = value;
    items.clear();
    await load();
  }

  Future<void> load() async {
    if (isLoading.value) return;
    isLoading.value = true;
    failure.value = null;
    try {
      final page = await _orders.list(
        scope: scope.value,
        page: 1,
        perPage: AppDefaults.pageSize,
      );
      _page = page.page;
      hasMore.value = page.hasMore;
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
      final page = await _orders.list(
        scope: scope.value,
        page: _page + 1,
        perPage: AppDefaults.pageSize,
      );
      _page = page.page;
      hasMore.value = page.hasMore;
      items.addAll(page.items);
    } on ApiFailure {
      // The list stays usable; the next scroll retries.
    } finally {
      isLoadingMore.value = false;
    }
  }
}
