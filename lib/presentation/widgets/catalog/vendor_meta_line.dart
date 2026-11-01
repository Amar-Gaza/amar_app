import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

class VendorMetaLine extends StatelessWidget {
  const VendorMetaLine({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
  });

  final IconData icon;
  final String text;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xs),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppSizes.iconXs,
              color: iconColor ?? context.appColors.mutedText,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              text,
              style: context.text.labelSmall
                  ?.copyWith(color: context.appColors.mutedText),
            ),
          ],
        ),
      );
}
