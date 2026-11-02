import '../masar/masar_models.dart';

/// Server categories that share one name, shown to the user as one category.
class CategoryGroup {
  const CategoryGroup({
    required this.name,
    required this.icon,
    required this.ids,
    required this.itemsCount,
  });

  final String name;
  final String? icon;
  final List<int> ids;
  final int itemsCount;

  /// Merges by trimmed name, keeping first-seen order; empty ones are dropped.
  static List<CategoryGroup> merge(Iterable<Category> categories) {
    final groups = <String, CategoryGroup>{};
    for (final category in categories) {
      if (category.productsCount == 0) continue;
      final name = category.name.trim();
      final current = groups[name];
      groups[name] = CategoryGroup(
        name: name,
        icon: current?.icon ?? category.icon,
        ids: [...?current?.ids, category.id],
        itemsCount: (current?.itemsCount ?? 0) + category.productsCount,
      );
    }
    return groups.values.toList();
  }
}
