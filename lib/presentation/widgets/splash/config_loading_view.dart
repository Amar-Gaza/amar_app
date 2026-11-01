import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../common/brand_wordmark.dart';
import '../common/icon_tile.dart';
import 'config_step_row.dart';

/// Light loading screen listing what the app prepares from the server.
class ConfigLoadingView extends StatelessWidget {
  const ConfigLoadingView({super.key});

  static const double _orbit = 150;
  static const double _ringAlpha = 0.4;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: BrandWordmark(),
              ),
              const Spacer(),
              Center(
                child: Container(
                  width: _orbit,
                  height: _orbit,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.brand.withValues(alpha: _ringAlpha),
                    ),
                  ),
                  child: const IconTile(
                    icon: LucideIcons.wrench,
                    size: AppSizes.iconTileLg,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.configLoadingTitle,
                textAlign: TextAlign.center,
                style: context.text.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.configLoadingMessage,
                textAlign: TextAlign.center,
                style: context.text.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceSoft,
                  borderRadius: AppRadius.lgAll,
                ),
                child: Column(
                  children: [
                    ConfigStepRow(
                      label: l10n.configStepVersion,
                      state: ConfigStepState.done,
                    ),
                    ConfigStepRow(
                      label: l10n.configStepSettings,
                      state: ConfigStepState.active,
                    ),
                    ConfigStepRow(
                      label: l10n.configStepModules,
                      state: ConfigStepState.pending,
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
