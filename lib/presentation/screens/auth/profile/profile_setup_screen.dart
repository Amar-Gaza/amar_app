import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../controllers/customer/profile_setup_controller.dart';
import '../../../../core/constants/api_rules.dart';
import '../../../../core/constants/app_defaults.dart';
import '../../../../core/localization/field_issue_resolver.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/auth/profile_avatar.dart';
import '../../../widgets/auth/step_progress.dart';
import '../../../widgets/common/app_text_field.dart';
import '../../../widgets/common/app_top_bar.dart';
import '../../../widgets/common/error_banner.dart';
import '../../../widgets/common/field_label.dart';
import '../../../widgets/common/language_sheet.dart';
import '../../../widgets/common/primary_button.dart';
import '../../../widgets/common/screen_scaffold.dart';
import '../../../widgets/common/select_row.dart';

class ProfileSetupScreen extends GetView<ProfileSetupController> {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ScreenScaffold(
      appBar: AppTopBar(title: l10n.profileScreenTitle, showBack: false),
      bottom: Obx(
        () => PrimaryButton(
          label: l10n.profileContinue,
          isLoading: controller.isSubmitting.value,
          onPressed: controller.submit,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StepProgress(
            label: l10n.profileStepLabel,
            value: AppDefaults.profileStepProgress,
          ),
          const SizedBox(height: AppSpacing.xl),
          const Center(child: ProfileAvatar()),
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.profileTitle, style: context.text.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(l10n.profileSubtitle, style: context.text.bodySmall),
          const SizedBox(height: AppSpacing.xl),
          Obx(() {
            final issue = controller.nameIssue.value;
            final server = controller.failure.value
                ?.fieldError(ProfileSetupController.nameField);
            return AppTextField(
              controller: controller.nameInput,
              label: l10n.profileNameLabel,
              hint: l10n.profileNameHint,
              prefixIcon: LucideIcons.user,
              keyboardType: TextInputType.name,
              maxLength: ApiRules.nameMaxLength,
              showCounter: true,
              errorText: issue != null
                  ? FieldIssueResolver.message(issue, l10n)
                  : server,
              onSubmitted: controller.submit,
            );
          }),
          const SizedBox(height: AppSpacing.md),
          FieldLabel(l10n.profileLanguageLabel),
          Obx(() {
            final code = controller.locale.value.languageCode;
            return SelectRow(
              value: LanguageSheet.label(l10n, code),
              onTap: () async {
                final picked = await LanguageSheet.show(context, code);
                if (picked != null) await controller.changeLanguage(picked);
              },
            );
          }),
          Obx(() {
            final failure = controller.failure.value;
            if (failure == null || failure.isValidation) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              child: ErrorBanner(failure: failure),
            );
          }),
        ],
      ),
    );
  }
}
