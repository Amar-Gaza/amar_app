import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../common/blinking_dot.dart';
import '../common/directional_icons.dart';
import '../common/square_icon_button.dart';

/// Floating back button and order pill over the job map.
class JobTopBar extends StatelessWidget {
  const JobTopBar({super.key, required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppRadius.mdAll,
                boxShadow: AppShadows.card(colors),
              ),
              child: SquareIconButton(
                icon: DirectionalIcons.back(context),
                tone: SquareIconTone.surface,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: onBack,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: context.scheme.surface,
                borderRadius: AppRadius.mdAll,
                boxShadow: AppShadows.card(colors),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlinkingDot(color: colors.amber),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    title,
                    style: context.text.labelMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
