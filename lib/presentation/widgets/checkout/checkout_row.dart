import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../common/directional_icons.dart';
import '../common/icon_tile.dart';

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
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.md,
      ),
      child: Material(
        color: context.scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(
            color: highlight ? colors.warning : colors.border,
          ),
        ),
        child: InkWell(
          borderRadius: AppRadius.lgAll,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconTile(
                  icon: icon,
                  size: AppSizes.iconTileSm,
                  iconSize: AppSizes.iconSm,
                ),
                const SizedBox(
                  width: AppSpacing.md,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.titleMedium?.copyWith(
                          color: colors.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.xs,
                      ),
                      Text(
                        value,
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: context.text.bodyMedium?.copyWith(
                          color: highlight ? colors.warning : colors.mutedText,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null) ...[
                  const SizedBox(
                    width: AppSpacing.sm,
                  ),
                  Icon(
                    DirectionalIcons.forward(context),
                    color: colors.ink,
                    size: AppSizes.iconSm,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
