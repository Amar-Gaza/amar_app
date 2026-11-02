import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'press_scale.dart';

/// Green gradient card: the active order and the account header.
class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return PressScale(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: colors.heroGradient,
          borderRadius: AppRadius.cardAll,
          boxShadow: AppShadows.hero(colors),
        ),
        child: child,
      ),
    );
  }
}
