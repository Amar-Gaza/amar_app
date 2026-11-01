import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../controllers/shared/app_config_controller.dart';
import '../../../../controllers/shared/session_controller.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/launcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/account/menu_tile.dart';
import '../../../widgets/common/app_top_bar.dart';
import '../../../widgets/common/avatar_initial.dart';
import '../../../widgets/common/confirmation_dialog.dart';
import '../../../widgets/common/state_tone.dart';

/// Account hub (account designs 01, 07, 14–16).
class AccountTab extends GetView<SessionController> {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final config = Get.find<AppConfigController>();
    final terms = config.config.value?.termsUrl;
    return Column(
      children: [
        AppTopBar(title: l10n.navAccount, showBack: false),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Obx(() {
                final user = controller.user.value;
                return Row(
                  children: [
                    AvatarInitial(
                      name: user?.name,
                      imageUrl: user?.avatarUrl,
                      size: AppSizes.iconTileLg,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? l10n.homeGreetingGuest,
                            style: context.text.titleLarge,
                          ),
                          if (user != null)
                            Text(
                              user.phone,
                              textDirection: TextDirection.ltr,
                              style: context.text.bodySmall,
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
                subtitle: l10n.accountEditProfileHint,
                onTap: () => Get.toNamed<void>(AppRoutes.editProfile),
              ),
              MenuTile(
                icon: LucideIcons.mapPin,
                title: l10n.accountAddresses,
                onTap: () => Get.toNamed<void>(AppRoutes.addresses),
              ),
              MenuTile(
                icon: LucideIcons.link,
                title: l10n.publicTrackingTitle,
                onTap: () => Get.toNamed<void>(AppRoutes.publicTracking),
              ),
              MenuTile(
                icon: LucideIcons.store,
                title: l10n.vendorApplyTitle,
                subtitle: l10n.vendorApplyHint,
                tone: StateTone.info,
                onTap: () => Get.toNamed<void>(AppRoutes.vendorApplication),
              ),
              MenuTile(
                icon: LucideIcons.headset,
                title: l10n.supportTitle,
                onTap: () => Get.toNamed<void>(AppRoutes.support),
              ),
              if (terms != null && terms.isNotEmpty)
                MenuTile(
                  icon: LucideIcons.fileText,
                  title: l10n.accountTerms,
                  onTap: () => Launcher.web(terms),
                ),
              const SizedBox(height: AppSpacing.md),
              MenuTile(
                icon: LucideIcons.logOut,
                title: l10n.homeLogout,
                tone: StateTone.danger,
                onTap: () async {
                  final confirmed = await ConfirmationDialog.show(
                    context,
                    l10n.logoutDialogMessage,
                  );
                  if (confirmed) await controller.signOut();
                },
              ),
              MenuTile(
                icon: LucideIcons.trash2,
                title: l10n.accountDelete,
                tone: StateTone.danger,
                onTap: () async {
                  final confirmed = await ConfirmationDialog.show(
                    context,
                    l10n.accountDeleteConfirm,
                  );
                  if (confirmed) await controller.deleteAccount();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
