import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../common/directional_icons.dart';
import '../common/icon_tile.dart';
import '../common/state_tone.dart';

/// One row of the account menu.
class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.tone = StateTone.brand,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final StateTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final danger = tone == StateTone.danger;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: context.scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: colors.border),
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
                  background: tone.background(colors),
                  foreground: tone.foreground(colors),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.text.titleSmall?.copyWith(
                          color: danger ? colors.danger : null,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: context.text.labelSmall
                              ?.copyWith(color: colors.mutedText),
                        ),
                    ],
                  ),
                ),
                Icon(DirectionalIcons.forward(context),
                    color: colors.mutedText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
