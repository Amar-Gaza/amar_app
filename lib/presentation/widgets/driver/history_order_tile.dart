import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/dashed_painter.dart';
import '../common/dot_pill.dart';
import '../common/state_tone.dart';
import 'driver_card.dart';
import 'route_stop.dart';

/// Finished job in the driver history: code, status, drop-off and time.
class HistoryOrderTile extends StatelessWidget {
  const HistoryOrderTile({
    super.key,
    required this.order,
    required this.cancelled,
    required this.onTap,
  });

  final OrderSummary order;
  final bool cancelled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final locale = Localizations.localeOf(context).languageCode;
    final at = order.completedAt ?? order.createdAt;
    return DriverCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TODO(design): the design shows the driver fee (+12 ₪) on the end
          // side; history items carry the order total only, not the fee.
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.orderCode(order.code),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleMedium,
                ),
              ),
              DotPill(
                label: order.status.label,
                tone: cancelled ? StateTone.danger : StateTone.success,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // TODO(design): the design also shows the pickup store; history
          // items have no pickup or vendor.
          RouteStop(
            color: colors.amber,
            label: l10n.orderDropoff,
            place: order.dropoff.label ?? l10n.orderPlaceUnknown,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomPaint(
            painter: DashedPainter(color: colors.border),
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.clock,
                    size: AppSizes.iconXs,
                    color: colors.mutedText,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    DateFormatter.time(at, locale),
                    style: context.text.labelMedium
                        ?.copyWith(color: colors.mutedText),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
