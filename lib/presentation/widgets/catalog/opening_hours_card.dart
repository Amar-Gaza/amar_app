import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../common/code_chip.dart';
import '../common/state_tone.dart';

/// Weekly hours from `opening_hours` ({sat: [["08:00","14:00"]], ...}).
class OpeningHoursCard extends StatelessWidget {
  const OpeningHoursCard({super.key, required this.hours});

  /// Server day keys in display order, with their [DateTime.weekday].
  static const List<(String, int)> _days = [
    ('sat', DateTime.saturday),
    ('sun', DateTime.sunday),
    ('mon', DateTime.monday),
    ('tue', DateTime.tuesday),
    ('wed', DateTime.wednesday),
    ('thu', DateTime.thursday),
    ('fri', DateTime.friday),
  ];

  /// 2024-01-01 is a Monday; used only to name weekdays.
  static final DateTime _monday = DateTime(2024);

  final Map<String, dynamic> hours;

  String _ranges(Object? value, String closed) {
    if (value is! List || value.isEmpty) return closed;
    return value
        .whereType<List<dynamic>>()
        .where((r) => r.length == 2)
        .map((r) => '${r[0]} – ${r[1]}')
        .join('، ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final locale = Localizations.localeOf(context).languageCode;
    final today = DateTime.now().weekday;
    final dayName = DateFormat.EEEE(locale);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.vendorHoursTitle, style: context.text.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          if (hours.isEmpty)
            Text(l10n.vendorHoursUnknown, style: context.text.bodySmall)
          else
            for (final (key, weekday) in _days)
              Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: colors.border)),
                ),
                child: Row(
                  children: [
                    Text(
                      dayName.format(
                        _monday.add(Duration(days: weekday - DateTime.monday)),
                      ),
                      style: context.text.labelMedium,
                    ),
                    if (weekday == today) ...[
                      const SizedBox(width: AppSpacing.sm),
                      CodeChip(label: l10n.vendorToday, tone: StateTone.brand),
                    ],
                    const Spacer(),
                    Text(
                      _ranges(hours[key], l10n.vendorDayClosed),
                      textDirection: TextDirection.ltr,
                      style: context.text.labelMedium
                          ?.copyWith(color: colors.mutedText),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
