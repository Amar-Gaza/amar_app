import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'code_chip.dart';
import 'link_button.dart';
import 'primary_button.dart';
import 'state_tone.dart';
import 'status_illustration.dart';

/// Full-area state: illustration, title, message and up to two actions.
class StateView extends StatelessWidget {
  const StateView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.tone = StateTone.brand,
    this.code,
    this.illustrationCaption,
    this.showDot = false,
    this.primaryLabel,
    this.onPrimary,
    this.isPrimaryLoading = false,
    this.secondaryLabel,
    this.onSecondary,
    this.footer,
  });

  final IconData icon;
  final String title;
  final String? message;
  final StateTone tone;
  final String? code;
  final String? illustrationCaption;
  final bool showDot;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final bool isPrimaryLoading;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final Widget? footer;

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.formMaxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: StatusIllustration(
                    icon: icon,
                    tone: tone,
                    caption: illustrationCaption,
                    showDot: showDot,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                if (code != null) ...[
                  Center(child: CodeChip(label: code!, tone: tone)),
                  const SizedBox(height: AppSpacing.sm),
                ],
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.text.headlineMedium,
                ),
                if (message != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: context.text.bodySmall,
                  ),
                ],
                if (primaryLabel != null) ...[
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryButton(
                    label: primaryLabel!,
                    onPressed: onPrimary,
                    isLoading: isPrimaryLoading,
                  ),
                ],
                if (secondaryLabel != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Center(
                    child: LinkButton(
                      label: secondaryLabel!,
                      onPressed: onSecondary,
                    ),
                  ),
                ],
                if (footer != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  footer!,
                ],
              ],
            ),
          ),
        ),
      );
}
