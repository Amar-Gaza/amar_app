import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Pill selector for order scopes.
class ScopeTabs extends StatelessWidget {
  const ScopeTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelect,
  });

  final Map<String, String> labels;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          for (final entry in labels.entries)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
              child: ChoiceChip(
                label: Text(entry.value),
                selected: entry.key == selected,
                onSelected: (_) => onSelect(entry.key),
                showCheckmark: false,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.pillAll,
                ),
                side: BorderSide(color: colors.border),
                selectedColor: colors.brandSoft,
                backgroundColor: context.scheme.surface,
                labelStyle: context.text.labelMedium?.copyWith(
                  color:
                      entry.key == selected ? colors.brand : colors.mutedText,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
