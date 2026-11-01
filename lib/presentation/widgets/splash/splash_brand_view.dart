import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../common/brand_wordmark.dart';

/// Dark launch screen: wordmark, tagline and a slim progress bar.
class SplashBrandView extends StatelessWidget {
  const SplashBrandView({super.key});

  static const double _taglineAlpha = 0.8;
  static const double _trackAlpha = 0.15;
  static const double _footAlpha = 0.5;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: colors.ink,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const Spacer(),
                const BrandWordmark(
                  markSize: AppSizes.brandMarkLg,
                  onDark: true,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.splashTagline,
                  style: context.text.bodyMedium?.copyWith(
                    color: colors.onInk.withValues(alpha: _taglineAlpha),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                SizedBox(
                  width: AppSizes.splashProgressWidth,
                  child: ClipRRect(
                    borderRadius: AppRadius.pillAll,
                    child: LinearProgressIndicator(
                      minHeight: AppSizes.splashProgressHeight,
                      color: colors.accent,
                      backgroundColor:
                          colors.onInk.withValues(alpha: _trackAlpha),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Text(
                    l10n.splashFooter,
                    style: context.text.labelSmall?.copyWith(
                      color: colors.onInk.withValues(alpha: _footAlpha),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
