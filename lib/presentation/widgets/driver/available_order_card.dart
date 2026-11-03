import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/compact_button.dart';
import '../common/dot_pill.dart';
import 'cash_tag.dart';
import 'driver_card.dart';
import 'driver_card_footer.dart';
import 'order_card_header.dart';
import 'route_steps.dart';

/// Offer card on the driver home: route, fee, cash to collect and accept.
class AvailableOrderCard extends StatelessWidget {
  const AvailableOrderCard({
    super.key,
    required this.order,
    required this.onAccept,
  });

  final DriverOrder order;

  /// Opens the order screen, where the offer is accepted.
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final distance = order.distanceToPickupKm ?? order.distanceKm;
    final collect = order.payment.collect;
    return DriverCard(
      onTap: onAccept,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TODO(design): the design also shows the trip minutes; the API has
          // no ETA field, so only the distance is shown.
          OrderCardHeader(
            icon: LucideIcons.shoppingBag,
            title: l10n.orderCode(order.code),
            subtitle: l10n.vendorDistance(distance.toStringAsFixed(1)),
            trailing: DotPill(label: l10n.driverNewBadge),
          ),
          const SizedBox(height: AppSpacing.md),
          RouteSteps(order: order),
          const SizedBox(height: AppSpacing.md),
          DriverCardFooter(
            label: l10n.driverYourFee,
            value: order.earning.formatted,
            trailing: [
              if (collect.amount > 0)
                CashTag(label: l10n.driverCashAmount(collect.formatted)),
              CompactButton(label: l10n.driverAcceptOrder, onPressed: onAccept),
            ],
          ),
        ],
      ),
    );
  }
}
