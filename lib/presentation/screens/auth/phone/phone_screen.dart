import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../controllers/customer/auth_controller.dart';
import '../../../../core/constants/api_query.dart';
import '../../../../core/constants/api_rules.dart';
import '../../../../core/localization/field_issue_resolver.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/auth/auth_body_text.dart';
import '../../../widgets/auth/auth_heading.dart';
import '../../../widgets/auth/consent_check.dart';
import '../../../widgets/auth/driver_entry_card.dart';
import '../../../widgets/auth/form_steps.dart';
import '../../../widgets/auth/phone_field.dart';
import '../../../widgets/common/app_text_field.dart';
import '../../../widgets/common/error_banner.dart';
import '../../../widgets/common/primary_button.dart';
import '../../../widgets/common/screen_scaffold.dart';
import '../../../widgets/common/segment_item.dart';
import '../../../widgets/common/segmented_tabs.dart';

/// Sign up and sign in by phone; both continue to the code screen.
class PhoneScreen extends GetView<AuthController> {
  const PhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ScreenScaffold(
      child: Obx(() {
        final signup = controller.isSignup.value;
        final failure = controller.failure.value;
        final nameIssue = controller.nameIssue.value;
        final phoneIssue = controller.phoneIssue.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FormSteps(current: 1),
            const SizedBox(height: AppSpacing.lg),
            AuthHeading(
              title: signup ? l10n.authSignupTitle : l10n.authLoginTitle,
              subtitle: AuthBodyText(
                signup ? l10n.authSignupSubtitle : l10n.authLoginSubtitle,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SegmentedTabs<bool>(
              selected: signup,
              onSelect: controller.setSignup,
              items: [
                SegmentItem(value: true, label: l10n.authTabSignup),
                SegmentItem(value: false, label: l10n.authTabLogin),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            if (signup) ...[
              AppTextField(
                controller: controller.nameInput,
                label: l10n.authNameLabel,
                hint: l10n.authNameHint,
                prefixIcon: LucideIcons.user,
                keyboardType: TextInputType.name,
                maxLength: ApiRules.nameMaxLength,
                errorText: nameIssue == null
                    ? failure?.fieldError(ApiBody.name)
                    : FieldIssueResolver.message(nameIssue, l10n),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            PhoneField(
              controller: controller.phoneInput,
              label: l10n.phoneLabel,
              hint: l10n.phoneHint,
              errorText: phoneIssue == null
                  ? failure?.fieldError(ApiBody.phone)
                  : FieldIssueResolver.message(phoneIssue, l10n),
              onSubmitted: controller.sendOtp,
            ),
            if (signup) ...[
              const SizedBox(height: AppSpacing.sm),
              ConsentCheck(
                value: controller.hasConsent.value,
                onChanged: controller.setConsent,
              ),
            ],
            if (failure != null && !failure.isValidation) ...[
              const SizedBox(height: AppSpacing.md),
              ErrorBanner(failure: failure),
            ],
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: signup ? l10n.authSignupSubmit : l10n.authLoginSubmit,
              isLoading: controller.isSubmitting.value,
              onPressed: controller.canSubmit.value ? controller.sendOtp : null,
            ),
            if (!signup) ...[
              const SizedBox(height: AppSpacing.md),
              DriverEntryCard(
                onTap: () => Get.toNamed<void>(AppRoutes.driverLogin),
              ),
            ],
          ],
        );
      }),
    );
  }
}
