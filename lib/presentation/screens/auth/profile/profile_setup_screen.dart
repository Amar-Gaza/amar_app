import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../controllers/customer/profile_setup_controller.dart';
import '../../../../core/constants/api_rules.dart';
import '../../../../core/constants/app_defaults.dart';
import '../../../../core/localization/field_issue_resolver.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/auth/auth_body_text.dart';
import '../../../widgets/auth/auth_heading.dart';
import '../../../widgets/auth/form_steps.dart';
import '../../../widgets/auth/phone_field.dart';
import '../../../widgets/auth/profile_avatar.dart';
import '../../../widgets/common/app_text_field.dart';
import '../../../widgets/common/error_banner.dart';
import '../../../widgets/common/link_button.dart';
import '../../../widgets/common/primary_button.dart';
import '../../../widgets/common/screen_scaffold.dart';

class ProfileSetupScreen extends GetView<ProfileSetupController> {
  const ProfileSetupScreen({super.key});

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
    return ScreenScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const FormSteps(current: 3),
          const SizedBox(height: AppSpacing.lg),
          AuthHeading(
            title: l10n.profileCompleteTitle,
            subtitle: AuthBodyText(l10n.profileCompleteSubtitle),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Obx(
              () => ProfileAvatar(
                name: controller.nameText.value,
                imagePath: controller.avatarPath.value,
                onTap: _pickAvatar,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Obx(() {
            final issue = controller.nameIssue.value;
            final server = controller.failure.value
                ?.fieldError(ProfileSetupController.nameField);
            return AppTextField(
              controller: controller.nameInput,
              label: l10n.authNameLabel,
              hint: l10n.profileFullNameHint,
              keyboardType: TextInputType.name,
              maxLength: ApiRules.nameMaxLength,
              errorText: issue != null
                  ? FieldIssueResolver.message(issue, l10n)
                  : server,
              onSubmitted: controller.submit,
            );
          }),
          const SizedBox(height: AppSpacing.sm),
          PhoneField(
            controller: controller.phoneInput,
            label: l10n.phoneLabel,
            hint: l10n.phoneHint,
            enabled: false,
            showIcon: false,
          ),
          Obx(() {
            final failure = controller.failure.value;
            if (failure == null || failure.isValidation) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: ErrorBanner(failure: failure),
            );
          }),
          const SizedBox(height: AppSpacing.md),
          Obx(
            () => PrimaryButton(
              label: l10n.commonContinue,
              isLoading: controller.isSubmitting.value,
              onPressed: controller.submit,
            ),
          ),
          Center(
            child: LinkButton(
              label: l10n.commonSkip,
              onPressed: controller.skip,
            ),
          ),
        ],
      ),
    );
  }
}
