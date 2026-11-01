import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/hex_color.dart';
import '../../../data/models/masar/masar_models.dart';

/// Status history with dots and a connecting line (design 06).
class TimelineList extends StatelessWidget {
  const TimelineList({super.key, required this.entries});

  static const double _line = 2;

  final List<TimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final locale = Localizations.localeOf(context).languageCode;
    return Column(
      children: [
        for (var i = 0; i < entries.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: AppSizes.iconMd,
                  child: Column(
                    children: [
                      Container(
                        width: AppSizes.offlineDot + AppSpacing.xs,
                        height: AppSizes.offlineDot + AppSpacing.xs,
                        margin: const EdgeInsets.only(top: AppSpacing.xs),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor.tryParse(entries[i].status.color) ??
                              colors.brand,
                        ),
                      ),
                      if (i < entries.length - 1)
                        Expanded(
                          child: Container(width: _line, color: colors.border),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entries[i].status.label,
                          style: context.text.titleSmall,
                        ),
                        Text(
                          DateFormatter.dayMonthTime(entries[i].at, locale),
                          style: context.text.labelSmall
                              ?.copyWith(color: colors.mutedText),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
