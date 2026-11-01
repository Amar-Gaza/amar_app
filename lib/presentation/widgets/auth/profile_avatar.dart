import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Placeholder avatar ringed by a thin border.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.border),
      ),
      child: Container(
        width: AppSizes.avatarLg,
        height: AppSizes.avatarLg,
        decoration:
            BoxDecoration(color: colors.brandSoft, shape: BoxShape.circle),
        child:
            Icon(LucideIcons.user, size: AppSizes.iconLg, color: colors.brand),
      ),
    );
  }
}
