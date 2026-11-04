import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/driver/driver_session_controller.dart';
import '../../../core/localization/vehicle_label.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/common/language_sheet.dart';
import '../../widgets/driver/profile_header.dart';
import '../../widgets/driver/profile_row.dart';

/// Driver profile summary and settings (designs 31, 33, 35).
class DriverAccountTab extends GetView<DriverSessionController> {
  const DriverAccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    void openProfile() => Get.toNamed<void>(AppRoutes.driverProfile);
    return Obx(() {
      final driver = controller.driver.value;
      return ListView(
        padding: const EdgeInsets.only(bottom: AppSizes.navBubble),
        children: [
          ProfileHeader(
            title: l10n.navAccount,
            name: driver?.name ?? '',
            subtitle: l10n.driverAccountSubtitle(
              // LTR isolate keeps the phone's leading "+" in place.
              '\u2066${driver?.phone ?? ''}\u2069',
            ),
            imageUrl: driver?.avatarUrl,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.lg,
              AppSpacing.page,
              0,
            ),
            child: Column(
              children: [
                ProfileRow(
                  icon: LucideIcons.userPen,
                  title: l10n.driverEditProfile,
                  onTap: openProfile,
                ),
                // TODO(design): license details are not in the API; the row
                // opens the profile screen where the vehicle type is edited.
                if (driver != null)
                  ProfileRow(
                    icon: LucideIcons.bike,
                    title: VehicleLabel.of(driver.vehicleType, l10n),
                    trailing: l10n.driverLicenseVehicle,
                    onTap: openProfile,
                  ),
                // TODO(design): "My documents" is in the design but the
                // driver API has no documents endpoint, so the row is hidden.
                ProfileRow(
                  icon: LucideIcons.bell,
                  title: l10n.navNotifications,
                  onTap: () => Get.toNamed<void>(AppRoutes.driverNotifications),
                ),
                // Language is saved with the profile (PUT /driver/me).
                ProfileRow(
                  icon: LucideIcons.globe,
                  title: l10n.driverLanguage,
                  trailing: LanguageSheet.label(
                    l10n,
                    driver?.locale ??
                        Localizations.localeOf(context).languageCode,
                  ),
                  onTap: openProfile,
                ),
                ProfileRow(
                  icon: LucideIcons.lifeBuoy,
                  title: l10n.supportTitle,
                  onTap: () => Get.toNamed<void>(AppRoutes.support),
                ),
                ProfileRow(
                  icon: LucideIcons.logOut,
                  title: l10n.homeLogout,
                  danger: true,
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
    });
  }
}
