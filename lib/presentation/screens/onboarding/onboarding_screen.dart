import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/common/brand_mark.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/screen_scaffold.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ScreenScaffold(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.huge),
          const BrandMark(size: AppSizes.brandMarkLg),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            l10n.onboardingTitle,
            textAlign: TextAlign.center,
            style: context.text.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.onboardingSubtitle,
            textAlign: TextAlign.center,
            style: context.text.bodySmall,
          ),
          const SizedBox(height: AppSpacing.huge),
          PrimaryButton(
            label: l10n.onboardingStart,
            onPressed: () => Get.toNamed<void>(AppRoutes.phone),
          ),
        ],
      ),
    );
  }
}
