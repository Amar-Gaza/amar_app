import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../common/press_scale.dart';

/// White rounded card with a soft brand shadow: driver order cards.
class DriverCard extends StatelessWidget {
  const DriverCard({super.key, required this.child, this.onTap});

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
          color: context.scheme.surface,
          borderRadius: AppRadius.sheetAll,
          border: Border.all(color: colors.border),
          boxShadow: AppShadows.card(colors),
        ),
        child: child,
      ),
    );
  }
}
