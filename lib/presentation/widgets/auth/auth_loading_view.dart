import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../common/icon_tile.dart';

/// Shown while the OTP is being verified and the session is prepared.
class AuthLoadingView extends StatelessWidget {
  const AuthLoadingView({super.key});

  static const double _ringAlpha = 0.5;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.formMaxWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.statusRing,
                height: AppSizes.statusRing,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.brand.withValues(alpha: _ringAlpha),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.brandSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.shieldCheck,
                    size: AppSizes.iconLg,
                    color: colors.brand,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.authLoadingTitle, style: context.text.headlineMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(l10n.authLoadingMessage, style: context.text.bodySmall),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.lgAll,
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    IconTile(
                      icon: LucideIcons.circle,
                      size: AppSizes.iconTileSm,
                      background: colors.surfaceSoft,
                      foreground: colors.surfaceSoft,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.authLoadingStep,
                            style: context.text.titleSmall,
                          ),
                          Text(
                            l10n.authLoadingKeepOpen,
                            style: context.text.labelSmall
                                ?.copyWith(color: colors.mutedText),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: AppSizes.iconSm,
                      height: AppSizes.iconSm,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSizes.loaderStroke,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
