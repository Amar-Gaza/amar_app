import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/customer/auth_controller.dart';
import '../../../../core/constants/api_rules.dart';
import '../../../../core/localization/error_message_resolver.dart';
import '../../../../core/localization/field_issue_resolver.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/auth/auth_heading.dart';
import '../../../widgets/auth/form_steps.dart';
import '../../../widgets/auth/otp_input.dart';
import '../../../widgets/auth/otp_resend_row.dart';
import '../../../widgets/auth/otp_sent_line.dart';
import '../../../widgets/common/directional_icons.dart';
import '../../../widgets/common/error_banner.dart';
import '../../../widgets/common/info_banner.dart';
import '../../../widgets/common/link_button.dart';
import '../../../widgets/common/primary_button.dart';
import '../../../widgets/common/screen_scaffold.dart';
import '../../../widgets/common/square_icon_button.dart';

/// Code entry, including the rejected-code variant.
class OtpForm extends GetView<AuthController> {
  const OtpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ScreenScaffold(
      child: Obx(() {
        final failure = controller.failure.value;
        final invalid = controller.isOtpInvalid;
        final issue = controller.otpIssue.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FormSteps(current: 2),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: SquareIconButton(
                icon: DirectionalIcons.back(context),
                onPressed: () => Get.back<void>(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AuthHeading(
              title: invalid ? l10n.otpInvalidTitle : l10n.otpConfirmTitle,
              subtitle: OtpSentLine(phone: controller.fullPhone.value),
            ),
            const SizedBox(height: AppSpacing.xl),
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
              length: ApiRules.otpLength,
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
              label: invalid ? l10n.otpTryAgain : l10n.otpVerifyAction,
              isLoading: controller.isSubmitting.value,
              onPressed: invalid
                  ? controller.retryOtp
                  : controller.otpCode.value.length == ApiRules.otpLength
                      ? controller.verify
                      : null,
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
