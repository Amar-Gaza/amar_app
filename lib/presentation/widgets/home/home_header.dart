import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../common/brand_wordmark.dart';
import '../common/square_icon_button.dart';

/// Brand, notifications and the location shortcut at the top of home.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.hasUnread,
    required this.locationLabel,
    required this.onNotifications,
    required this.onLocation,
  });

  final bool hasUnread;
  final String locationLabel;
  final VoidCallback onNotifications;
  final VoidCallback onLocation;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const BrandWordmark(),
              const Spacer(),
              SquareIconButton(
                icon: LucideIcons.bell,
                onPressed: onNotifications,
                showDot: hasUnread,
                tooltip: AppLocalizations.of(context).navNotifications,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: onLocation,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.mapPin,
                  size: AppSpacing.lg,
                  color: colors.brand,
                ),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    locationLabel,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        context.text.labelMedium?.copyWith(color: colors.brand),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
