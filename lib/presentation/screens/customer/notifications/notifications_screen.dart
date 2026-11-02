import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../controllers/customer/notifications_controller.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_top_bar.dart';
import '../../../widgets/common/empty_view.dart';
import '../../../widgets/common/error_view.dart';
import '../../../widgets/common/skeleton_list.dart';
import '../../../widgets/notifications/notification_tile.dart';

/// Notifications list: GET /v1/notifications, read-all and opened.
class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Column(
        children: [
          Obx(
            () => AppTopBar(
              title: l10n.navNotifications,
              trailing: controller.hasUnread
                  ? IconButton(
                      tooltip: l10n.notificationsReadAll,
                      onPressed: controller.readAll,
                      icon: const Icon(LucideIcons.checkCheck),
                    )
                  : null,
            ),
          ),
          Expanded(
            child: Obx(() {
              final failure = controller.failure.value;
              if (controller.isLoading.value && controller.items.isEmpty) {
                return const SkeletonList(showSearch: false);
              }
              if (failure != null && controller.items.isEmpty) {
                return ErrorView(failure: failure, onRetry: controller.load);
              }
              if (controller.items.isEmpty) {
                return EmptyView(
                  icon: LucideIcons.bell,
                  title: l10n.notificationsEmptyTitle,
                  message: l10n.notificationsEmptyMessage,
                  actionLabel: l10n.commonRefresh,
                  onAction: controller.load,
                );
              }
              return RefreshIndicator(
                onRefresh: controller.load,
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: controller.items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (_, index) {
                    final item = controller.items[index];
                    return NotificationTile(
                      notification: item,
                      onTap: () => controller.open(item),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
