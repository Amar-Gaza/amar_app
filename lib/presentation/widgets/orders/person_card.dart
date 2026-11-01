import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/launcher.dart';
import '../common/avatar_initial.dart';

/// Driver / customer contact row with a call button (designs 12, 13).
class PersonCard extends StatelessWidget {
  const PersonCard({
    super.key,
    required this.name,
    required this.subtitle,
    this.phone,
    this.avatarUrl,
  });

  final String name;
  final String subtitle;
  final String? phone;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          AvatarInitial(name: name, imageUrl: avatarUrl),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: context.text.titleSmall),
                Text(
                  subtitle,
                  style: context.text.labelSmall
                      ?.copyWith(color: colors.mutedText),
                ),
              ],
            ),
          ),
          if (phone != null)
            IconButton.filled(
              onPressed: () => Launcher.call(phone!),
              style: IconButton.styleFrom(backgroundColor: colors.brand),
              icon: Icon(LucideIcons.phone, color: colors.onBrand),
            ),
        ],
      ),
    );
  }
}
