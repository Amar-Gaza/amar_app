import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/auth/onboarding_page.dart';
import '../../widgets/auth/page_dots.dart';
import '../../widgets/common/link_button.dart';
import '../../widgets/common/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pages = PageController();
  int _index = 0;

  int get _last => AppAssets.onboarding.length - 1;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _openAuth() => Get.toNamed<void>(AppRoutes.phone);

  void _next() {
    if (_index == _last) {
      _openAuth();
      return;
    }
    _pages.nextPage(duration: AppDurations.page, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slides = [
      (l10n.onboarding1Title, l10n.onboarding1Body),
      (l10n.onboarding2Title, l10n.onboarding2Body),
      (l10n.onboarding3Title, l10n.onboarding3Body),
    ];
    return Scaffold(
      backgroundColor: context.appColors.brandSoft,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: AppSizes.squareButton,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: _index == _last
                    ? null
                    : LinkButton(label: l10n.commonSkip, onPressed: _openAuth),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pages,
                itemCount: slides.length,
                onPageChanged: (index) => setState(() => _index = index),
                itemBuilder: (_, index) => OnboardingPage(
                  image: AppAssets.onboarding[index],
                  title: slides[index].$1,
                  body: slides[index].$2,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            PageDots(count: slides.length, current: _index),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: PrimaryButton(
                label: _index == _last ? l10n.onboardingStart : l10n.commonNext,
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
