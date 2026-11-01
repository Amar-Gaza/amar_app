import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';

/// Thin warning strip shown above content while the device is offline.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      color: colors.warningSoft,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).stateOfflineBanner,
            style: context.text.labelSmall?.copyWith(color: colors.warning),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(LucideIcons.wifi, size: AppSizes.iconXs, color: colors.warning),
        ],
      ),
    );
  }
}
