import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../catalog/category_icon.dart';
import '../common/icon_tile.dart';
import '../common/state_tone.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
    required this.tone,
    required this.onTap,
  });

  final Category category;
  final StateTone tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.lgAll,
      child: SizedBox(
        width: AppSizes.categoryTile + AppSpacing.xl,
        child: Column(
          children: [
            IconTile(
              icon: categoryIcon(category.icon),
              size: AppSizes.categoryTile,
              borderRadius: AppRadius.lgAll,
              background: tone.background(colors),
              foreground: tone.foreground(colors),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              category.name.trim(),
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
