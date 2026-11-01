import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';

/// Rounded tinted square holding a single icon.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.icon,
    this.size = AppSizes.iconTile,
    this.iconSize = AppSizes.iconMd,
    this.background,
    this.foreground,
    this.borderRadius = AppRadius.lgAll,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final Color? background;
  final Color? foreground;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? colors.brandSoft,
        borderRadius: borderRadius,
      ),
      child: Icon(icon, size: iconSize, color: foreground ?? colors.brand),
    );
  }
}
