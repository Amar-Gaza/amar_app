import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';

/// Round avatar: photo when available, otherwise the first letter.
class AvatarInitial extends StatelessWidget {
  const AvatarInitial({
    super.key,
    this.name,
    this.imageUrl,
    this.size = AppSizes.avatarSm,
  });

  static const double _letterRatio = 0.42;

  final String? name;
  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final trimmed = name?.trim() ?? '';
    final Widget child;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      child = CachedNetworkImage(imageUrl: imageUrl!, fit: BoxFit.cover);
    } else if (trimmed.isNotEmpty) {
      child = Center(
        child: Text(
          trimmed.characters.first,
          style: TextStyle(
            color: colors.brand,
            fontSize: size * _letterRatio,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    } else {
      child = Icon(LucideIcons.user, color: colors.brand);
    }
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration:
          BoxDecoration(color: colors.brandSoft, shape: BoxShape.circle),
      child: child,
    );
  }
}
