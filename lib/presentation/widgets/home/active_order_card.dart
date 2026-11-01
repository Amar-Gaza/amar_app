import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/directional_icons.dart';
import '../common/icon_tile.dart';

/// Dark banner on home for the customer's most recent active order.
class ActiveOrderCard extends StatelessWidget {
  const ActiveOrderCard({super.key, required this.order, required this.onTap});

  static const double _tileAlpha = 0.12;
  static const double _captionAlpha = 0.7;

  final OrderSummary order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Material(
        color: colors.ink,
        borderRadius: AppRadius.lgAll,
        child: InkWell(
          borderRadius: AppRadius.lgAll,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                IconTile(
                  icon: LucideIcons.receiptText,
                  size: AppSizes.iconTileSm,
                  iconSize: AppSizes.iconSm,
                  background: colors.onInk.withValues(alpha: _tileAlpha),
                  foreground: colors.accent,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeActiveOrderTitle,
                        style: context.text.labelSmall?.copyWith(
                          color: colors.onInk.withValues(alpha: _captionAlpha),
                        ),
                      ),
                      Text(
                        order.status.label,
                        style: context.text.titleMedium
                            ?.copyWith(color: colors.onInk),
                      ),
                      Text(
                        l10n.orderCode(order.code),
                        style: context.text.labelSmall
                            ?.copyWith(color: colors.accent),
                      ),
                    ],
                  ),
                ),
                Icon(DirectionalIcons.forward(context), color: colors.onInk),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
