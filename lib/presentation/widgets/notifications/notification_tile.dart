import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/masar/masar_models.dart';
import '../common/icon_tile.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final locale = Localizations.localeOf(context).languageCode;
    final unread = notification.readAt == null;
    return Material(
      color: unread ? colors.surfaceSoft : context.scheme.surface,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IconTile(
                icon: LucideIcons.bell,
                size: AppSizes.iconTileSm,
                iconSize: AppSizes.iconSm,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.title, style: context.text.titleSmall),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      notification.body,
                      style: context.text.labelSmall
                          ?.copyWith(color: colors.mutedText),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      DateFormatter.dayMonthTime(
                        notification.createdAt,
                        locale,
                      ),
                      style: context.text.labelSmall
                          ?.copyWith(color: colors.subtleText),
                    ),
                  ],
                ),
              ),
              if (unread)
                Container(
                  width: AppSizes.offlineDot,
                  height: AppSizes.offlineDot,
                  decoration: BoxDecoration(
                    color: colors.brand,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
