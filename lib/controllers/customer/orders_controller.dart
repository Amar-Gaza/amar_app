import 'package:get/get.dart';

import '../../core/constants/api_query.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/order_service.dart';
import 'shell_controller.dart';

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
  bool _reloadQueued = false;

  @override
  void onInit() {
    super.onInit();
    load();
    if (Get.isRegistered<ShellController>()) {
      ever<CustomerTab>(Get.find<ShellController>().tab, (tab) {
        if (tab == CustomerTab.orders) load();
      });
    }
  }

  /// Called after an order is placed: show it in the active list at once.
  Future<void> showNewOrder() async {
    if (scope.value != OrderScope.active) {
      scope.value = OrderScope.active;
      items.clear();
    }
    await load();
  }

  Future<void> selectScope(String value) async {
    if (scope.value == value) return;
    scope.value = value;
    items.clear();
    await load();
  }

  Future<void> load() async {
    if (isLoading.value) {
      _reloadQueued = true;
      return;
    }
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
    if (_reloadQueued) {
      _reloadQueued = false;
      await load();
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
