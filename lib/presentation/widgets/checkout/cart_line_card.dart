import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/cart/cart_item.dart';
import '../../../l10n/app_localizations.dart';
import '../catalog/quantity_stepper.dart';
import '../common/network_thumb.dart';

/// Cart line with quantity editing and removal (designs 01–03).
class CartLineCard extends StatelessWidget {
  const CartLineCard({
    super.key,
    required this.item,
    this.onQtyChanged,
    this.onRemove,
    this.maxQty,
  });

  final CartItem item;
  final ValueChanged<int>? onQtyChanged;
  final VoidCallback? onRemove;
  final int? maxQty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final choices = item.choiceLabels;
    final editable = onQtyChanged != null;
    final limit = maxQty ?? item.product.stock;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: AppRadius.mdAll,
                child: SizedBox.square(
                  dimension: AppSizes.productImage,
                  child: NetworkThumb(url: item.product.imageUrl),
                ),
              ),
              if (onRemove != null)
                PositionedDirectional(
                  top: AppSpacing.xs,
                  start: AppSpacing.xs,
                  child: SizedBox.square(
                    dimension: AppSizes.iconXl,
                    child: IconButton.filled(
                      padding: EdgeInsets.zero,
                      tooltip: l10n.cartRemove,
                      onPressed: onRemove,
                      style: IconButton.styleFrom(
                        backgroundColor: colors.dangerSoft,
                      ),
                      icon: Icon(
                        LucideIcons.trash2,
                        size: AppSizes.iconSm,
                        color: colors.danger,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: context.text.titleMedium),
                Text(
                  choices.isEmpty ? l10n.cartNoOptions : choices.join(' · '),
                  style: context.text.labelSmall
                      ?.copyWith(color: colors.mutedText),
                ),
                Text(
                  l10n.cartPriceByServer,
                  style: context.text.labelSmall?.copyWith(color: colors.brand),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (editable)
                  QuantityStepper(
                    value: item.qty,
                    onDecrement:
                        item.qty > 1 ? () => onQtyChanged!(item.qty - 1) : null,
                    onIncrement: limit == null || item.qty < limit
                        ? () => onQtyChanged!(item.qty + 1)
                        : null,
                  )
                else
                  Text(
                    l10n.cartQty(item.qty),
                    style: context.text.labelMedium,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
