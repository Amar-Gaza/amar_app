import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/bindings/driver_binding.dart';
import '../../../controllers/customer/notifications_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/common/directional_icons.dart';
import '../../widgets/common/empty_view.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/skeleton_list.dart';
import '../../widgets/common/square_icon_button.dart';
import '../../widgets/driver/driver_notification_tile.dart';

/// Driver inbox (designs 33, 34A, 34B).
class DriverNotificationsScreen extends GetView<NotificationsController> {
  const DriverNotificationsScreen({super.key});

  @override
  String? get tag => driverTag;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.sm,
                AppSpacing.page,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  SquareIconButton(
                    icon: DirectionalIcons.back(context),
                    tooltip:
                        MaterialLocalizations.of(context).backButtonTooltip,
                    onPressed: () => Get.back<void>(),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      l10n.navNotifications,
                      style: context.text.headlineLarge,
                    ),
                  ),
                  SquareIconButton(
                    icon: LucideIcons.checkCheck,
                    tone: SquareIconTone.mint,
                    tooltip: l10n.notificationsReadAll,
                    onPressed: controller.readAll,
                  ),
                ],
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
                    actionLabel: l10n.commonRefresh,
                    onAction: controller.load,
                  );
                }
                return RefreshIndicator(
                  onRefresh: controller.load,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.page,
                      0,
                      AppSpacing.page,
                      AppSpacing.xl,
                    ),
                    itemCount: controller.items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (_, i) => DriverNotificationTile(
                      notification: controller.items[i],
                      onTap: () => controller.open(controller.items[i]),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
