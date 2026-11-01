import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/masar_icons.dart';
import '../common/icon_tile.dart';
import 'status_chip.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, this.onTap});

  final OrderSummary order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final colors = context.appColors;
    return Material(
      color: context.scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgAll,
        side: BorderSide(color: colors.border),
      ),
      child: InkWell(
        borderRadius: AppRadius.lgAll,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              IconTile(
                icon: masarIcon(order.status.icon),
                size: AppSizes.iconTileSm,
                iconSize: AppSizes.iconSm,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.orderCode(order.code),
                            style: context.text.titleMedium,
                          ),
                        ),
                        StatusChip(status: order.status),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      [
                        DateFormatter.dayMonthTime(order.createdAt, locale),
                        if (order.itemsCount != null)
                          l10n.orderItemsCount(order.itemsCount!),
                      ].join(' · '),
                      style: context.text.labelSmall
                          ?.copyWith(color: colors.mutedText),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      order.total.formatted,
                      style: context.text.titleSmall
                          ?.copyWith(color: colors.brand),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
