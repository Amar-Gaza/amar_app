import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../checkout/label_value_row.dart';
import '../orders/status_chip.dart';

/// Job card in the available list and on the dashboard (04, 08).
class DriverOrderCard extends StatelessWidget {
  const DriverOrderCard({super.key, required this.order, required this.onTap});

  final DriverOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.code,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.start,
                      style: context.text.titleMedium,
                    ),
                  ),
                  StatusChip(status: order.status),
                ],
              ),
              const Divider(height: AppSpacing.lg),
              LabelValueRow(
                icon: LucideIcons.store,
                label: l10n.orderPickup,
                value: order.vendor?.name ??
                    order.pickup.label ??
                    l10n.orderPlaceUnknown,
              ),
              LabelValueRow(
                icon: LucideIcons.mapPin,
                label: l10n.orderDropoff,
                value: order.dropoff.label ?? l10n.orderPlaceUnknown,
              ),
              LabelValueRow(
                icon: LucideIcons.route,
                label: l10n.quoteDistance,
                value: l10n.vendorDistance(
                  (order.distanceToPickupKm ?? order.distanceKm)
                      .toStringAsFixed(1),
                ),
              ),
              LabelValueRow(
                icon: LucideIcons.banknote,
                label: l10n.driverCollect,
                value: order.payment.collect.formatted,
              ),
              LabelValueRow(
                icon: LucideIcons.wallet,
                label: l10n.driverEarning,
                value: order.earning.formatted,
                valueStyle:
                    context.text.titleSmall?.copyWith(color: colors.brand),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
