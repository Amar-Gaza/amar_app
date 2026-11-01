import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

/// Fixed-height horizontal list used by home sections.
class HorizontalStrip<T> extends StatelessWidget {
  const HorizontalStrip({
    super.key,
    required this.items,
    required this.height,
    required this.itemBuilder,
  });

  final List<T> items;
  final double height;
  final Widget Function(T item) itemBuilder;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
          itemBuilder: (_, index) => itemBuilder(items[index]),
        ),
      );
}
