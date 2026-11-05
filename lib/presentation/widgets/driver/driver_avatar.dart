import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';

/// Rounded gradient square with the driver's photo or first letter.
class DriverAvatar extends StatelessWidget {
  const DriverAvatar({super.key, this.name, this.imageUrl});

  final String? name;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final trimmed = name?.trim() ?? '';
    final url = imageUrl;
    return Container(
      width: AppSizes.driverAvatar,
      height: AppSizes.driverAvatar,
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: colors.brandGradient,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.button(colors),
      ),
      child: url != null && url.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              width: AppSizes.driverAvatar,
              height: AppSizes.driverAvatar,
            )
          : Text(
              trimmed.isEmpty ? '' : trimmed.characters.first,
              style:
                  context.text.headlineMedium?.copyWith(color: colors.onBrand),
            ),
    );
  }
}
