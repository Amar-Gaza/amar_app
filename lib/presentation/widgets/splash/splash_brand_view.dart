import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../common/brand_mark.dart';

/// Green launch screen: logo, name, tagline and a filling progress bar.
class SplashBrandView extends StatelessWidget {
  const SplashBrandView({super.key});

  static const double _trackAlpha = 0.25;
  static const double _popFrom = 0.3;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(gradient: colors.heroGradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: _popFrom, end: 1),
                duration: AppDurations.splashPop,
                curve: Curves.easeOutBack,
                builder: (_, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: const BrandMark(
                  size: AppSizes.brandMarkXl,
                  onGradient: true,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.brandName,
                style: context.text.headlineMedium?.copyWith(
                  color: colors.onBrand,
                  fontSize: AppTypography.splash,
                ),
              ),
              Text(
                l10n.splashTagline,
                style: context.text.bodyMedium?.copyWith(color: colors.accent),
              ),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: AppSizes.splashProgressWidth,
                child: ClipRRect(
                  borderRadius: AppRadius.pillAll,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: AppDurations.splashBar,
                    builder: (_, value, __) => LinearProgressIndicator(
                      value: value,
                      minHeight: AppSizes.splashBarHeight,
                      color: colors.onBrand,
                      backgroundColor:
                          colors.onBrand.withValues(alpha: _trackAlpha),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
