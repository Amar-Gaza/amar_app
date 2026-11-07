import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/duration_formatter.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import 'label_value_row.dart';
import 'payment_label.dart';

/// Server-computed price breakdown of a quote (designs 12 and 14).
class PriceCard extends StatelessWidget {
  const PriceCard({super.key, required this.quote, this.secondsLeft});

  final Quote quote;
  final int? secondsLeft;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final extra = quote.breakdown
        .where((l) => !PriceLineKeys.standard.contains(l.key))
        .toList();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.quoteDetailsTitle,
                  style: context.text.titleMedium,
                ),
              ),
              if (secondsLeft != null) ...[
                Icon(
                  LucideIcons.clock,
                  size: AppSizes.iconXs,
                  color: colors.warning,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  DurationFormatter.clock(secondsLeft!),
                  style:
                      context.text.labelSmall?.copyWith(color: colors.warning),
                ),
              ],
            ],
          ),
          const Divider(height: AppSpacing.xl),
          LabelValueRow(
            label: l10n.quoteItemsTotal,
            value: quote.itemsTotal.formatted,
          ),
          for (final line in extra)
            LabelValueRow(label: line.label, value: line.formatted),
          LabelValueRow(
            label: l10n.quoteDeliveryFee,
            value: quote.deliveryFee.formatted,
          ),
          if (quote.discount.amount != 0)
            LabelValueRow(
              label: l10n.quoteDiscount,
              value: quote.discount.formatted,
              valueStyle:
                  context.text.titleSmall?.copyWith(color: colors.success),
            ),
          const Divider(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: Text(l10n.quoteTotal, style: context.text.titleLarge),
              ),
              Text(
                quote.total.formatted,
                style: context.text.headlineSmall?.copyWith(
                  color: colors.brand,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.xl),
          LabelValueRow(
            label: l10n.checkoutPayment,
            value: paymentLabel(l10n, quote.paymentMethod),
          ),
        ],
      ),
    );
  }
}

/// Breakdown keys already shown as dedicated rows.
abstract final class PriceLineKeys {
  static const Set<String> standard = {
    'items',
    'items_total',
    'delivery',
    'delivery_fee',
    'discount',
    'coupon',
    'total',
    // Delivery fee clamped to its min/max; already inside delivery_fee.
    'min_max',
  };
}
