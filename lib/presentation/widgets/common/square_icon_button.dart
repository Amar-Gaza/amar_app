import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';

enum SquareIconTone { soft, mint, brand, surface }

/// Rounded square action: back, notifications, call and message buttons.
class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tone = SquareIconTone.soft,
    this.size = AppSizes.squareButton,
    this.showDot = false,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final SquareIconTone tone;
  final double size;
  final bool showDot;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final (background, foreground) = switch (tone) {
      SquareIconTone.soft => (colors.surfaceSoft, colors.ink),
      SquareIconTone.mint => (colors.brandSoft, colors.brand),
      SquareIconTone.brand => (colors.brand, colors.onBrand),
      SquareIconTone.surface => (context.scheme.surface, colors.ink),
    };
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onPressed,
          tooltip: tooltip,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tightFor(width: size, height: size),
          iconSize: AppSizes.iconSm,
          color: foreground,
          style: IconButton.styleFrom(
            backgroundColor: background,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.mdAll,
            ),
          ),
          icon: Icon(icon),
        ),
        if (showDot)
          PositionedDirectional(
            top: AppSizes.attentionDot,
            end: AppSizes.attentionDot,
            child: IgnorePointer(
              child: Container(
                width: AppSizes.attentionDot,
                height: AppSizes.attentionDot,
                decoration: BoxDecoration(
                  color: colors.amber,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
