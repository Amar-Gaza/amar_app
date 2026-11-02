import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'press_scale.dart';

/// White bordered card; tappable when [onTap] is set.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.elevated = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: context.scheme.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: colors.border),
        boxShadow: elevated ? AppShadows.card(colors) : null,
      ),
      child: child,
    );
    return onTap == null ? card : PressScale(onTap: onTap, child: card);
  }
}
