import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

enum ConfigStepState { done, active, pending }

/// One line of the config loading checklist.
class ConfigStepRow extends StatelessWidget {
  const ConfigStepRow({super.key, required this.label, required this.state});

  final String label;
  final ConfigStepState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final Widget marker = switch (state) {
      ConfigStepState.done =>
        Icon(LucideIcons.check, size: AppSizes.iconXs, color: colors.brand),
      ConfigStepState.active => const SizedBox(
          width: AppSizes.iconXs,
          height: AppSizes.iconXs,
          child: CircularProgressIndicator(strokeWidth: AppSizes.loaderStroke),
        ),
      ConfigStepState.pending => const SizedBox(width: AppSizes.iconXs),
    };
    final style = switch (state) {
      ConfigStepState.done =>
        context.text.labelMedium?.copyWith(color: colors.brand),
      ConfigStepState.active => context.text.labelMedium,
      ConfigStepState.pending =>
        context.text.labelSmall?.copyWith(color: colors.mutedText),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          marker,
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(label, style: style)),
        ],
      ),
    );
  }
}
