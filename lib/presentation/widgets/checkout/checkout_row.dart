import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../common/directional_icons.dart';
import '../common/icon_tile.dart';

/// Icon, title, value and a chevron; opens the step that edits it.
class CheckoutRow extends StatelessWidget {
  const CheckoutRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  /// Marks a row that still needs input.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: context.scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: highlight ? colors.warning : colors.border),
        ),
        child: InkWell(
          borderRadius: AppRadius.lgAll,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                IconTile(
                  icon: icon,
                  size: AppSizes.iconTileSm,
                  iconSize: AppSizes.iconSm,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.text.titleSmall),
                      Text(
                        value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.labelSmall?.copyWith(
                          color: highlight ? colors.warning : colors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(DirectionalIcons.forward(context), color: colors.ink),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
