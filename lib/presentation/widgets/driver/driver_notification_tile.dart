import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/masar/masar_models.dart';
import '../common/press_scale.dart';
import '../common/state_tone.dart';

/// Driver inbox row: tinted icon by event, title, body, time and an amber
/// dot while unread.
class DriverNotificationTile extends StatelessWidget {
  const DriverNotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  static const double _unreadBorderAlpha = 0.25;

  final AppNotification notification;
  final VoidCallback onTap;

  // The contract has no event enum, so the icon is picked by keyword.
  static (IconData, StateTone) _look(String event) {
    final e = event.toLowerCase();
    if (e.contains('cash') || e.contains('settle') || e.contains('earning')) {
      return (LucideIcons.banknote, StateTone.warning);
    }
    if (e.contains('deliver')) return (LucideIcons.circleCheck, StateTone.info);
    if (e.contains('order') || e.contains('offer')) {
      return (LucideIcons.shoppingBag, StateTone.success);
    }
    return (LucideIcons.bell, StateTone.brand);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final locale = Localizations.localeOf(context).languageCode;
    final unread = notification.readAt == null;
    final (icon, tone) = _look(notification.event);
    return PressScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: unread ? colors.surfaceSoft : context.scheme.surface,
          borderRadius: AppRadius.cardAll,
          border: Border.all(
            color: unread
                ? colors.brandBright.withValues(alpha: _unreadBorderAlpha)
                : colors.border,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppSizes.iconTileSm,
              height: AppSizes.iconTileSm,
              decoration: BoxDecoration(
                color: tone.background(colors),
                borderRadius: AppRadius.mdAll,
              ),
              child: Icon(
                icon,
                size: AppSizes.iconSm,
                color: tone.foreground(colors),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title, style: context.text.titleMedium),
                  Text(
                    notification.body,
                    style: context.text.labelMedium?.copyWith(
                      color: colors.mutedText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    DateFormatter.dayMonthTime(notification.createdAt, locale),
                    style: context.text.labelSmall
                        ?.copyWith(color: colors.subtleText),
                  ),
                ],
              ),
            ),
            if (unread) ...[
              const SizedBox(width: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Container(
                  width: AppSizes.attentionDot,
                  height: AppSizes.attentionDot,
                  decoration: BoxDecoration(
                    color: colors.amber,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
