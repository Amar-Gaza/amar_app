import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'segment_button.dart';
import 'segment_item.dart';

/// Tinted track with equal-width options, shared by every tabbed screen.
class SegmentedTabs<T> extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  final List<SegmentItem<T>> items;
  final T selected;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: context.appColors.surfaceSoft,
          borderRadius: AppRadius.buttonAll,
        ),
        child: Row(
          children: [
            for (final item in items)
              Expanded(
                child: SegmentButton(
                  label: item.label,
                  count: item.count,
                  selected: item.value == selected,
                  onTap: () => onSelect(item.value),
                ),
              ),
          ],
        ),
      );
}
