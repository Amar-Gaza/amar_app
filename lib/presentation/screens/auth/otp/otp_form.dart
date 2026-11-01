import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../controllers/customer/auth_controller.dart';
import '../../../../core/localization/error_message_resolver.dart';
import '../../../../core/localization/field_issue_resolver.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/auth/auth_intro.dart';
import '../../../widgets/auth/otp_input.dart';
import '../../../widgets/auth/otp_resend_row.dart';
import '../../../widgets/auth/phone_line.dart';
import '../../../widgets/common/app_top_bar.dart';
import '../../../widgets/common/error_banner.dart';
import '../../../widgets/common/info_banner.dart';
import '../../../widgets/common/link_button.dart';
import '../../../widgets/common/primary_button.dart';
import '../../../widgets/common/screen_scaffold.dart';
import '../../../widgets/common/state_tone.dart';

/// Code entry, including the rejected-code variant.
class OtpForm extends GetView<AuthController> {
  const OtpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ScreenScaffold(
      appBar: AppTopBar(title: l10n.otpScreenTitle, showBrand: false),
      child: Obx(() {
        final failure = controller.failure.value;
        final invalid = controller.isOtpInvalid;
        final issue = controller.otpIssue.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthIntro(
              centered: true,
              icon: invalid ? LucideIcons.circleAlert : LucideIcons.shieldCheck,
              tone: invalid ? StateTone.danger : StateTone.brand,
              title: invalid ? l10n.otpInvalidTitle : l10n.otpTitle,
              subtitle: invalid ? l10n.otpInvalidMessage : null,
              below: invalid
                  ? null
                  : PhoneLine(
                      phone: controller.fullPhone.value,
                      changeLabel: l10n.otpChangePhone,
                      onChange: () => Get.back<void>(),
                    ),
            ),
            if (invalid) ...[
              InfoBanner(
                title: l10n.otpInvalidBannerTitle,
                message: ErrorMessageResolver.resolve(failure!, l10n),
              ),
              const SizedBox(height: AppSpacing.xl),
            ] else if (failure != null) ...[
              ErrorBanner(failure: failure),
              const SizedBox(height: AppSpacing.xl),
            ],
            OtpInput(
              controller: controller.otpInput,
              length: controller.otpLength.value,
              value: controller.otpCode.value,
              hasError: invalid,
              onChanged: controller.setCode,
            ),
            if (issue != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                FieldIssueResolver.message(issue, l10n),
                textAlign: TextAlign.center,
                style: context.text.labelSmall
                    ?.copyWith(color: context.appColors.danger),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            if (!invalid)
              OtpResendRow(
                secondsLeft: controller.secondsLeft.value,
                onResend: controller.resendOtp,
              ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: invalid ? l10n.otpTryAgain : l10n.otpVerify,
              isLoading: controller.isSubmitting.value,
              onPressed: invalid ? controller.retryOtp : controller.verify,
            ),
            if (invalid)
              Center(
                child: LinkButton(
                  label: l10n.otpSendNew,
                  onPressed: controller.canResend ? controller.resendOtp : null,
                ),
              ),
          ],
        );
      }),
    );
  }
}
