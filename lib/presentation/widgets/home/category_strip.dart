import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/models/masar/masar_models.dart';
import '../common/state_tone.dart';
import 'category_tile.dart';

/// Horizontal row of categories with rotating tints.
class CategoryStrip extends StatelessWidget {
  const CategoryStrip({
    super.key,
    required this.categories,
    required this.onTap,
  });

  static const List<StateTone> _tones = [
    StateTone.brand,
    StateTone.danger,
    StateTone.warning,
    StateTone.info,
  ];

  final List<Category> categories;
  final ValueChanged<Category> onTap;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < categories.length; i++)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                child: CategoryTile(
                  category: categories[i],
                  tone: _tones[i % _tones.length],
                  onTap: () => onTap(categories[i]),
                ),
              ),
          ],
        ),
      );
}
