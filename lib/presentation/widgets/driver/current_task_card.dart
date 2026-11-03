import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/compact_button.dart';
import '../common/dot_pill.dart';
import '../common/state_tone.dart';
import 'driver_card.dart';
import 'driver_card_footer.dart';
import 'order_card_header.dart';

/// The driver's assigned order on the home: status and the next step.
class CurrentTaskCard extends StatelessWidget {
  const CurrentTaskCard({super.key, required this.order, required this.onOpen});

  final DriverOrder order;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return DriverCard(
      onTap: onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OrderCardHeader(
            icon: LucideIcons.navigation,
            title: l10n.orderCode(order.code),
            subtitle: order.status.label,
            trailing: DotPill(
              label: l10n.driverInProgress,
              tone: StateTone.warning,
              dotColor: colors.amber,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DriverCardFooter(
            label: l10n.driverNextStep,
            value: order.nextAction?.label ?? order.status.label,
            trailing: [
              CompactButton(label: l10n.driverContinueTask, onPressed: onOpen),
            ],
          ),
        ],
      ),
    );
  }
}
