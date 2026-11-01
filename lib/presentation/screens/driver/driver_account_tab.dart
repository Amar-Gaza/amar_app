import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/driver/driver_session_controller.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/account/menu_tile.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/avatar_initial.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/common/state_tone.dart';

/// Driver profile summary and settings (designs 31, 33, 35).
class DriverAccountTab extends GetView<DriverSessionController> {
  const DriverAccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        AppTopBar(title: l10n.navAccount, showBack: false),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Obx(() {
                final driver = controller.driver.value;
                return Row(
                  children: [
                    AvatarInitial(
                      name: driver?.name,
                      imageUrl: driver?.avatarUrl,
                      size: AppSizes.iconTileLg,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(driver?.name ?? '',
                              style: context.text.titleLarge),
                          Text(
                            driver?.phone ?? '',
                            textDirection: TextDirection.ltr,
                            style: context.text.bodySmall,
                          ),
                          if (driver != null)
                            Text(
                              '${driver.vehicleType} · ★ ${driver.rating.average.toStringAsFixed(1)}',
                              style: context.text.labelSmall,
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: AppSpacing.xl),
              MenuTile(
                icon: LucideIcons.userPen,
                title: l10n.accountEditProfile,
                subtitle: l10n.driverProfileHint,
                onTap: () => Get.toNamed<void>(AppRoutes.driverProfile),
              ),
              MenuTile(
                icon: LucideIcons.bell,
                title: l10n.navNotifications,
                onTap: () => Get.toNamed<void>(AppRoutes.driverNotifications),
              ),
              const SizedBox(height: AppSpacing.md),
              MenuTile(
                icon: LucideIcons.logOut,
                title: l10n.homeLogout,
                tone: StateTone.danger,
                onTap: () async {
                  final ok = await ConfirmationDialog.show(
                    context,
                    l10n.logoutDialogMessage,
                  );
                  if (ok) await controller.logout();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
