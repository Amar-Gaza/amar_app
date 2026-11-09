import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/dot_pill.dart';
import '../common/state_tone.dart';
import 'route_stop.dart';

/// Details of a finished job. The server shows a driver an order only
/// while it is active, so history uses the data it already has.
class HistoryOrderSheet extends StatelessWidget {
  const HistoryOrderSheet({
    super.key,
    required this.order,
    required this.cancelled,
  });

  final OrderSummary order;
  final bool cancelled;

  static Future<void> show(
    BuildContext context, {
    required OrderSummary order,
    required bool cancelled,
  }) =>
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (_) => HistoryOrderSheet(order: order, cancelled: cancelled),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final locale = Localizations.localeOf(context).languageCode;
    final at = (order.completedAt ?? order.createdAt).toLocal();
    final details = order.dropoff.details?.trim() ?? '';
    final count = order.itemsCount;

    Widget row(IconData icon, String label, String value) => Padding(
          padding: const EdgeInsets.only(top: AppSpacing.md),
          child: Row(
            children: [
              Icon(icon, size: AppSizes.iconSm, color: colors.mutedText),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: context.text.bodyMedium
                      ?.copyWith(color: colors.mutedText),
                ),
              ),
              Text(value, style: context.text.titleSmall),
            ],
          ),
        );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          0,
          AppSpacing.page,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.orderCode(order.code),
                    style: context.text.titleLarge,
                  ),
                ),
                DotPill(
                  label: order.status.label,
                  tone: cancelled ? StateTone.danger : StateTone.success,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            RouteStop(
              color: colors.amber,
              label: l10n.orderDropoff,
              place: order.dropoff.label ?? l10n.orderPlaceUnknown,
            ),
            if (details.isNotEmpty && details != order.dropoff.label) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                details,
                style:
                    context.text.bodyMedium?.copyWith(color: colors.mutedText),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            const Divider(),
            if (count != null)
              row(LucideIcons.package, l10n.orderItemsCount(count), ''),
            row(
              LucideIcons.receipt,
              l10n.driverHistoryTotal,
              order.total.formatted,
            ),
            row(
              LucideIcons.clock,
              l10n.receiptDate,
              DateFormatter.dayMonthTime(at, locale),
            ),
          ],
        ),
      ),
    );
  }
}
