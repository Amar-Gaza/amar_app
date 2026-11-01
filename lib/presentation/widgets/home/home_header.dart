import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../common/avatar_initial.dart';
import '../catalog/cart_button.dart';
import '../common/brand_wordmark.dart';

/// Wordmark at the start; notifications and the user avatar at the end.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.userName,
    required this.avatarUrl,
    required this.onNotifications,
    required this.onAccount,
  });

  final String? userName;
  final String? avatarUrl;
  final VoidCallback onNotifications;
  final VoidCallback onAccount;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          const BrandWordmark(),
          const Spacer(),
          const CartButton(),
          SizedBox(
            width: AppSizes.avatarSm,
            height: AppSizes.avatarSm,
            child: IconButton.outlined(
              onPressed: onNotifications,
              style: IconButton.styleFrom(
                backgroundColor: context.scheme.surface,
                side: BorderSide(color: colors.border),
              ),
              icon: Icon(LucideIcons.bell,
                  size: AppSizes.iconSm, color: colors.ink),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: onAccount,
            child: AvatarInitial(name: userName, imageUrl: avatarUrl),
          ),
        ],
      ),
    );
  }
}
