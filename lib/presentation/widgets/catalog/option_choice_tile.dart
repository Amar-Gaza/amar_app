import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Radio (single) or checkbox (multi) row for a product choice.
class OptionChoiceTile extends StatelessWidget {
  const OptionChoiceTile({
    super.key,
    required this.label,
    required this.priceLabel,
    required this.selected,
    required this.multi,
    required this.onTap,
  });

  final String label;
  final String? priceLabel;
  final bool selected;
  final bool multi;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final Widget marker = multi
        ? Container(
            width: AppSizes.iconMd,
            height: AppSizes.iconMd,
            decoration: BoxDecoration(
              color: selected ? colors.brand : null,
              borderRadius: AppRadius.smAll,
              border: Border.all(
                color: selected ? colors.brand : colors.subtleText,
                width: AppSizes.borderWidthActive,
              ),
            ),
            child: selected
                ? Icon(LucideIcons.check,
                    size: AppSizes.iconXs, color: colors.onBrand)
                : null,
          )
        : Container(
            width: AppSizes.iconMd,
            height: AppSizes.iconMd,
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? colors.brand : colors.subtleText,
                width: AppSizes.borderWidthActive,
              ),
            ),
            child: selected
                ? DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.brand,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          );
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: selected ? colors.surfaceSoft : context.scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: selected ? colors.brand : colors.border),
        ),
        child: InkWell(
          borderRadius: AppRadius.lgAll,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                marker,
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: context.text.titleSmall),
                      if (priceLabel != null)
                        Text(
                          priceLabel!,
                          style: context.text.labelSmall
                              ?.copyWith(color: colors.mutedText),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
