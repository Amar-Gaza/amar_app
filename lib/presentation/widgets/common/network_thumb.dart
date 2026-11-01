import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';

/// Network image with a neutral placeholder when missing or failing.
class NetworkThumb extends StatelessWidget {
  const NetworkThumb({super.key, required this.url, this.height});

  final String? url;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final placeholder = Container(
      height: height,
      color: colors.surfaceSoft,
      alignment: Alignment.center,
      child: Icon(LucideIcons.imageOff,
          size: AppSizes.iconMd, color: colors.subtleText),
    );
    if (url == null || url!.isEmpty) return placeholder;
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, __) => placeholder,
      errorWidget: (_, __, ___) => placeholder,
    );
  }
}
