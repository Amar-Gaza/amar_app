import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../controllers/customer/auth_controller.dart';
import '../../../../core/constants/app_defaults.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/auth/auth_loading_view.dart';
import '../../../widgets/common/app_top_bar.dart';
import '../../../widgets/common/error_view.dart';
import '../../../widgets/common/state_tone.dart';
import '../../../widgets/common/state_view.dart';
import 'otp_form.dart';

/// Verification flow: form, invalid code, expired code and signing-in.
class OtpScreen extends GetView<AuthController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Obx(() {
      final failure = controller.failure.value;
      if (controller.isOtpExpired) {
        return Scaffold(
          appBar: AppTopBar(title: l10n.otpExpiredTitle, showBrand: false),
          body: StateView(
            icon: LucideIcons.clock,
            tone: StateTone.warning,
            illustrationCaption: AppDefaults.otpTimerPlaceholder,
            title: l10n.otpExpiredTitle,
            message: l10n.otpExpiredHint,
            primaryLabel: l10n.otpSendNew,
            isPrimaryLoading: controller.isSubmitting.value,
            onPrimary: controller.resendOtp,
            secondaryLabel: l10n.otpUseDifferentNumber,
            onSecondary: () => Get.back<void>(),
          ),
        );
      }
      if (failure != null && failure.isUnavailable) {
        return Scaffold(
          appBar: AppTopBar(title: l10n.otpScreenTitle, showBrand: false),
          body: ErrorView(failure: failure, onRetry: controller.retryOtp),
        );
      }
      // The form stays mounted under the loader so its text field is never
      // torn down mid-frame.
      return Stack(
        children: [
          const OtpForm(),
          if (controller.isVerifying)
            Positioned.fill(
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                child: const SafeArea(child: AuthLoadingView()),
              ),
            ),
        ],
      );
    });
  }
}
