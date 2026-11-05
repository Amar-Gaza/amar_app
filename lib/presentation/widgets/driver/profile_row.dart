import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../common/directional_icons.dart';
import '../common/press_scale.dart';

/// Soft row of the driver account list: icon tile, title, optional trailing
/// text and a chevron. [danger] styles the logout row.
class ProfileRow extends StatelessWidget {
  const ProfileRow({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final foreground = danger ? colors.danger : colors.ink;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Semantics(
        button: true,
        child: PressScale(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: danger ? colors.dangerSoft : colors.surfaceSoft,
              borderRadius: AppRadius.lgAll,
            ),
            child: Row(
              children: [
                Container(
                  width: AppSizes.squareButton - AppSpacing.sm,
                  height: AppSizes.squareButton - AppSpacing.sm,
                  decoration: BoxDecoration(
                    color: danger ? context.scheme.surface : colors.brandSoft,
                    borderRadius: AppRadius.mdAll,
                  ),
                  child: Icon(
                    icon,
                    size: AppSizes.iconXs,
                    color: danger ? colors.danger : colors.brand,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleSmall?.copyWith(
                      color: foreground,
                      fontSize: context.text.bodyMedium?.fontSize,
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    trailing!,
                    style: context.text.labelMedium?.copyWith(
                      color: colors.mutedText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (!danger) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    DirectionalIcons.forward(context),
                    size: AppSizes.iconXs,
                    color: colors.subtleText,
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
