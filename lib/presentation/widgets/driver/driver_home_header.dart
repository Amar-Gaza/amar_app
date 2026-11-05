import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/square_icon_button.dart';
import 'driver_avatar.dart';
import 'online_toggle_pill.dart';

/// Avatar, greeting, the online switch and the notifications bell.
class DriverHomeHeader extends StatelessWidget {
  const DriverHomeHeader({
    super.key,
    required this.driver,
    required this.online,
    required this.toggling,
    required this.onToggle,
    required this.onNotifications,
  });

  final Driver? driver;
  final bool online;
  final bool toggling;
  final VoidCallback onToggle;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Row(
      children: [
        DriverAvatar(name: driver?.name, imageUrl: driver?.avatarUrl),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.driverGreeting,
                style:
                    context.text.labelMedium?.copyWith(color: colors.mutedText),
              ),
              Text(
                driver?.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.headlineSmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        OnlineTogglePill(online: online, busy: toggling, onToggle: onToggle),
        const SizedBox(width: AppSpacing.sm),
        // TODO(design): the bell shows an unread dot in the design; the driver
        // home has no unread count yet.
        SquareIconButton(
          icon: LucideIcons.bell,
          size: AppSizes.buttonHeightSm,
          tooltip: l10n.navNotifications,
          onPressed: onNotifications,
        ),
      ],
    );
  }
}
