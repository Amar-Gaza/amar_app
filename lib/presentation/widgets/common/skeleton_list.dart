import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import 'skeleton_box.dart';

/// Global loading state: search bar, filter chips and list rows.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.rows = 4, this.showSearch = true});

  static const int _chips = 3;
  static const double _lineMid = 0.75;
  static const double _lineShort = 0.5;

  final int rows;
  final bool showSearch;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              if (showSearch) ...[
                const SkeletonBox(
                  height: AppSizes.skeletonSearch,
                  borderRadius: AppRadius.mdAll,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    for (var i = 0; i < _chips; i++)
                      const Padding(
                        padding: EdgeInsetsDirectional.only(end: AppSpacing.sm),
                        child: SkeletonBox(
                          width: AppSizes.skeletonChipWidth,
                          height: AppSizes.skeletonChipHeight,
                          borderRadius: AppRadius.pillAll,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              for (var i = 0; i < rows; i++)
                Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.lgAll,
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      const SkeletonBox(
                        width: AppSizes.skeletonThumb,
                        height: AppSizes.skeletonThumb,
                        borderRadius: AppRadius.mdAll,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, box) => Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SkeletonBox(height: AppSizes.skeletonLine),
                              const SizedBox(height: AppSpacing.sm),
                              SkeletonBox(
                                width: box.maxWidth * _lineMid,
                                height: AppSizes.skeletonLine,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              SkeletonBox(
                                width: box.maxWidth * _lineShort,
                                height: AppSizes.skeletonLine,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context).stateLoadingContent,
                style:
                    context.text.labelSmall?.copyWith(color: colors.mutedText),
              ),
              const SizedBox(width: AppSpacing.sm),
              const SizedBox(
                width: AppSizes.iconXs,
                height: AppSizes.iconXs,
                child: CircularProgressIndicator(
                  strokeWidth: AppSizes.loaderStroke,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
