import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Minus / value / plus, laid out left-to-right in both languages.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    this.large = false,
  });

  final int value;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final size = large ? AppSizes.avatarSm + AppSpacing.xs : AppSizes.iconXl;
    Widget button(IconData icon, VoidCallback? onTap) => SizedBox.square(
          dimension: size,
          child: IconButton.outlined(
            padding: EdgeInsets.zero,
            onPressed: onTap,
            style: IconButton.styleFrom(
              side: BorderSide(
                color: onTap == null ? colors.border : colors.brand,
              ),
            ),
            icon: Icon(
              icon,
              size: AppSizes.iconSm,
              color: onTap == null ? colors.subtleText : colors.brand,
            ),
          ),
        );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(LucideIcons.minus, onDecrement),
          SizedBox(
            width: size,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style:
                  large ? context.text.headlineLarge : context.text.titleLarge,
            ),
          ),
          button(LucideIcons.plus, onIncrement),
        ],
      ),
    );
  }
}
