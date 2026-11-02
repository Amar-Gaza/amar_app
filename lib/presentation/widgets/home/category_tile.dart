import 'package:flutter/material.dart';

import '../../../core/theme/app_category_tints.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/catalog/category_group.dart';
import '../catalog/category_icon.dart';
import '../common/icon_tile.dart';
import '../common/press_scale.dart';

/// Tinted icon with the category name below it.
class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
    required this.index,
    required this.onTap,
  });

  final CategoryGroup category;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = AppCategoryTints.at(index);
    return PressScale(
      onTap: onTap,
      child: Column(
        children: [
          IconTile(
            icon: categoryIcon(category.icon),
            size: AppSizes.categoryIconTile,
            borderRadius: AppRadius.cardAll,
            background: background,
            foreground: foreground,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            category.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: context.text.labelMedium,
          ),
        ],
      ),
    );
  }
}
