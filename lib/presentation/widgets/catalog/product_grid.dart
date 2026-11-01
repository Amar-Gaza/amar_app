import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/models/masar/masar_models.dart';
import 'product_grid_card.dart';

/// Two-column product grid with an infinite-scroll hook.
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.onOpen,
    required this.onAdd,
    this.onEndReached,
    this.isLoadingMore = false,
    this.header,
    this.shrinkWrap = false,
  });

  static const int _columns = 2;
  static const double _aspect = 0.68;
  static const double _loadMoreExtent = 300;

  final List<Product> products;
  final ValueChanged<Product> onOpen;
  final ValueChanged<Product> onAdd;
  final VoidCallback? onEndReached;
  final bool isLoadingMore;
  final Widget? header;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final grid = SliverPadding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _columns,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: _aspect,
        ),
        itemCount: products.length,
        itemBuilder: (_, index) => ProductGridCard(
          product: products[index],
          onTap: () => onOpen(products[index]),
          onAdd: () => onAdd(products[index]),
        ),
      ),
    );
    final view = CustomScrollView(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      slivers: [
        if (header != null) SliverToBoxAdapter(child: header),
        grid,
        if (isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xl),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
    if (onEndReached == null) return view;
    return NotificationListener<ScrollNotification>(
      onNotification: (scroll) {
        if (scroll.metrics.extentAfter < _loadMoreExtent) onEndReached!();
        return false;
      },
      child: view,
    );
  }
}
