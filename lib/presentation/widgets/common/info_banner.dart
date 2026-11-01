import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'state_tone.dart';

/// Tinted inline notice with an icon, a title and an optional message.
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.title,
    this.message,
    this.tone = StateTone.danger,
    this.icon = LucideIcons.circleAlert,
  });

  final String title;
  final String? message;
  final StateTone tone;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final foreground = tone.foreground(colors);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: tone.background(colors),
        borderRadius: AppRadius.mdAll,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSizes.iconSm, color: foreground),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.text.titleSmall?.copyWith(color: foreground),
                ),
                if (message != null && message!.isNotEmpty)
                  Text(
                    message!,
                    style: context.text.labelSmall?.copyWith(color: foreground),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
