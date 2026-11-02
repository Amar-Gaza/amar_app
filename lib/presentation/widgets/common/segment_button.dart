import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// A single option inside the segmented control.
class SegmentButton extends StatelessWidget {
  const SegmentButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.count,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.segment,
        height: AppSizes.segmentHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? context.scheme.surface : null,
          borderRadius: AppRadius.segmentInnerAll,
          boxShadow: selected ? AppShadows.selected(colors) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.labelLarge?.copyWith(
                  color: selected ? colors.brand : colors.mutedText,
                ),
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Container(
                constraints: const BoxConstraints(
                  minWidth: AppSizes.segmentCount,
                ),
                height: AppSizes.segmentCount,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: selected ? colors.brand : colors.brandSoft,
                  borderRadius: AppRadius.pillAll,
                ),
                child: Text(
                  '$count',
                  style: context.text.labelSmall?.copyWith(
                    color: selected ? colors.onBrand : colors.brand,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
