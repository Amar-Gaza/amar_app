import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:io';

import '../../../controllers/customer/edit_profile_controller.dart';
import '../../../core/constants/api_rules.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/localization/field_issue_resolver.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/avatar_initial.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/field_label.dart';
import '../../widgets/common/language_sheet.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/select_row.dart';

/// Edit name, photo and language (account design 02).
class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({super.key});

  Future<void> _pickAvatar() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: AppDefaults.imageQuality,
    );
    if (file != null) controller.avatarPath.value = file.path;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppTopBar(title: l10n.accountEditProfile),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: Obx(() {
              final path = controller.avatarPath.value;
              return GestureDetector(
                onTap: _pickAvatar,
                child: Stack(
                  children: [
                    if (path != null)
                      CircleAvatar(
                        radius: AppSizes.avatarLg / 2,
                        backgroundImage: FileImage(File(path)),
                      )
                    else
                      AvatarInitial(
                        name: controller.name.text,
                        imageUrl: controller.avatarUrl,
                        size: AppSizes.avatarLg,
                      ),
                    PositionedDirectional(
                      bottom: 0,
                      end: 0,
                      child: CircleAvatar(
                        radius: AppSizes.iconSm * 0.7,
                        backgroundColor: context.appColors.brand,
                        child: Icon(
                          LucideIcons.camera,
                          size: AppSizes.iconXs,
                          color: context.appColors.onBrand,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.xl),
          Obx(
            () => AppTextField(
              controller: controller.name,
              label: l10n.profileNameLabel,
              hint: l10n.profileNameHint,
              prefixIcon: LucideIcons.user,
              maxLength: ApiRules.nameMaxLength,
              showCounter: true,
              errorText: controller.nameIssue.value == null
                  ? null
                  : FieldIssueResolver.message(
                      controller.nameIssue.value!, l10n),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FieldLabel(l10n.profileLanguageLabel),
          Obx(
            () => SelectRow(
              value: LanguageSheet.label(l10n, controller.language.value),
              onTap: () async {
                final picked = await LanguageSheet.show(
                  context,
                  controller.language.value,
                );
                if (picked != null) controller.language.value = picked;
              },
            ),
          ),
          Obx(() {
            final failure = controller.failure.value;
            return failure == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: ErrorBanner(failure: failure),
                  );
          }),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: Obx(
          () => PrimaryButton(
            label: l10n.commonSave,
            isLoading: controller.isSaving.value,
            onPressed: () async {
              if (await controller.save()) Get.back<void>();
            },
          ),
        ),
      ),
    );
  }
}
