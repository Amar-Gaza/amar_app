import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';

/// Cash handed to management, shown in the wallet transactions list.
class SettlementTile extends StatelessWidget {
  const SettlementTile({super.key, required this.settlement});

  final CashSettlement settlement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final locale = Localizations.localeOf(context).languageCode;
    final note = settlement.note;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.scheme.surface,
        borderRadius: AppRadius.cardAll,
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.iconTileSm,
            height: AppSizes.iconTileSm,
            decoration: BoxDecoration(
              color: colors.dangerSoft,
              borderRadius: AppRadius.mdAll,
            ),
            child: Icon(
              LucideIcons.handCoins,
              size: AppSizes.iconSm,
              color: colors.danger,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note == null || note.isEmpty
                      ? l10n.driverCashSettlement
                      : note,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleMedium,
                ),
                Text(
                  DateFormatter.dayMonthTime(settlement.at, locale),
                  style: context.text.labelSmall
                      ?.copyWith(color: colors.mutedText),
                ),
              ],
            ),
          ),
          Text(
            '−${settlement.amount.formatted}',
            textDirection: TextDirection.ltr,
            style: context.text.titleMedium?.copyWith(
              color: colors.danger,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
