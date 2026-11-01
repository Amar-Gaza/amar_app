import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../controllers/customer/auth_controller.dart';
import '../../../../core/constants/api_query.dart';
import '../../../../core/localization/field_issue_resolver.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/auth/auth_intro.dart';
import '../../../widgets/auth/consent_text.dart';
import '../../../widgets/auth/language_toggle.dart';
import '../../../widgets/auth/phone_field.dart';
import '../../../widgets/common/app_top_bar.dart';
import '../../../widgets/common/brand_mark.dart';
import '../../../widgets/common/error_banner.dart';
import '../../../widgets/common/link_button.dart';
import '../../../widgets/common/primary_button.dart';
import '../../../widgets/common/screen_scaffold.dart';

class PhoneScreen extends GetView<AuthController> {
  const PhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ScreenScaffold(
      appBar: const AppTopBar(
        showBack: false,
        leading: BrandMark(),
        trailing: LanguageToggle(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthIntro(
            icon: LucideIcons.phone,
            title: l10n.phoneTitle,
            subtitle: l10n.phoneSubtitle,
          ),
          Obx(() {
            final issue = controller.phoneIssue.value;
            final server = controller.failure.value?.fieldError(ApiBody.phone);
            return PhoneField(
              controller: controller.phoneInput,
              label: l10n.phoneLabel,
              hint: l10n.phoneHint,
              helper: l10n.phoneHelper,
              errorText: issue != null
                  ? FieldIssueResolver.message(issue, l10n)
                  : server,
              onSubmitted: controller.sendOtp,
            );
          }),
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
          const SizedBox(height: AppSpacing.xl),
          Obx(
            () => PrimaryButton(
              label: l10n.phoneSend,
              isLoading: controller.isSubmitting.value,
              onPressed: controller.sendOtp,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: LinkButton(
              label: l10n.driverEntry,
              onPressed: () => Get.toNamed<void>(AppRoutes.driverLogin),
            ),
          ),
          ConsentText(
            prefix: l10n.consentPrefix,
            terms: l10n.consentTerms,
            separator: l10n.consentAnd,
            privacy: l10n.consentPrivacy,
          ),
        ],
      ),
    );
  }
}
