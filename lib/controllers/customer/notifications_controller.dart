import 'package:get/get.dart';

import '../../core/constants/app_defaults.dart';
import '../../core/network/api_failure.dart';
import '../../core/storage/secure_token_storage.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/shared/notification_service.dart';
import '../shared/push_controller.dart';

class NotificationsController extends GetxController {
  NotificationsController(
    this._service, {
    this.role = SessionRole.customer,
  });

  final NotificationService _service;
  final SessionRole role;

  final RxList<AppNotification> items = <AppNotification>[].obs;
  final RxBool isLoading = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();

  bool get hasUnread => items.any((n) => n.readAt == null);

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
      final page = await _service.list(perPage: AppDefaults.pageSize);
      items.assignAll(page.items);
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> readAll() async {
    try {
      await _service.readAll();
      await load();
    } on ApiFailure catch (e) {
      failure.value = e;
    }
  }

  /// Reports the open, then shows the order the notification is about.
  Future<void> open(AppNotification notification) async {
    if (Get.isRegistered<PushController>()) {
      Get.find<PushController>()
          .openTarget(role, notification.data, fromInbox: true);
    }
    if (notification.openedAt != null) return;
    try {
      final updated = await _service.markOpened(notification.id);
      final index = items.indexWhere((n) => n.id == notification.id);
      if (index >= 0) items[index] = updated;
    } on ApiFailure {
      // Opening is best-effort; the item stays as it was.
    }
  }
}
