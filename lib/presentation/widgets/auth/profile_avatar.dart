import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Large avatar with a camera badge: picked photo, the saved [imageUrl], or
/// the name's first letter.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.name,
    required this.imagePath,
    required this.onTap,
    this.imageUrl,
  });

  static const double _letterRatio = 0.38;
  static const double _ringWidth = 4;
  static const double _badgeRing = 3;

  final String name;
  final String? imagePath;
  final VoidCallback onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final surface = context.scheme.surface;
    final trimmed = name.trim();
    final path = imagePath;
    final url = imageUrl;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: AppSizes.profileAvatar,
        child: Stack(
          children: [
            Container(
              width: AppSizes.profileAvatar,
              height: AppSizes.profileAvatar,
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: colors.brandSoft,
                shape: BoxShape.circle,
                border: Border.all(color: surface, width: _ringWidth),
                boxShadow: AppShadows.card(colors),
              ),
              child: path != null
                  ? Image.file(
                      File(path),
                      width: AppSizes.profileAvatar,
                      height: AppSizes.profileAvatar,
                      fit: BoxFit.cover,
                    )
                  : url != null && url.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: url,
                          width: AppSizes.profileAvatar,
                          height: AppSizes.profileAvatar,
                          fit: BoxFit.cover,
                        )
                      : trimmed.isEmpty
                          ? Icon(
                              LucideIcons.user,
                              size: AppSizes.iconXl,
                              color: colors.brand,
                            )
                          : Text(
                              trimmed.characters.first,
                              style: context.text.headlineMedium?.copyWith(
                                color: colors.brand,
                                fontSize: AppSizes.profileAvatar * _letterRatio,
                              ),
                            ),
            ),
            PositionedDirectional(
              bottom: AppSpacing.xs / 2,
              end: AppSpacing.xs / 2,
              child: Container(
                width: AppSizes.avatarBadge,
                height: AppSizes.avatarBadge,
                decoration: BoxDecoration(
                  color: colors.brandBright,
                  shape: BoxShape.circle,
                  border: Border.all(color: surface, width: _badgeRing),
                ),
                child: Icon(
                  LucideIcons.camera,
                  size: AppSizes.iconXs,
                  color: colors.onBrand,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
