import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/models/catalog/category_group.dart';
import 'category_tile.dart';

/// Four-column grid of categories.
class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    super.key,
    required this.categories,
    required this.onTap,
  });

  static const int _columns = 4;

  final List<CategoryGroup> categories;
  final ValueChanged<CategoryGroup> onTap;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (_, constraints) {
          const gaps = AppSpacing.sm * (_columns - 1);
          final width = (constraints.maxWidth - gaps) / _columns;
          return Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.md,
            children: [
              for (final (index, category) in categories.indexed)
                SizedBox(
                  width: width,
                  child: CategoryTile(
                    category: category,
                    index: index,
                    onTap: () => onTap(category),
                  ),
                ),
            ],
          );
        },
      );
}
