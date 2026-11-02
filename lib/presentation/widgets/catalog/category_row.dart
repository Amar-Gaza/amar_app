import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/catalog/category_group.dart';
import '../../../l10n/app_localizations.dart';
import '../common/directional_icons.dart';
import '../common/icon_tile.dart';
import '../common/state_tone.dart';
import 'category_icon.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({
    super.key,
    required this.category,
    required this.tone,
    required this.onTap,
  });

  final CategoryGroup category;
  final StateTone tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
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
                icon: categoryIcon(category.icon),
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
                    Text(category.name, style: context.text.titleSmall),
                    Text(
                      AppLocalizations.of(context)
                          .categoryProductsCount(category.itemsCount),
                      style: context.text.labelSmall
                          ?.copyWith(color: colors.mutedText),
                    ),
                  ],
                ),
              ),
              Icon(DirectionalIcons.forward(context), color: colors.mutedText),
            ],
          ),
        ),
      ),
    );
  }
}
