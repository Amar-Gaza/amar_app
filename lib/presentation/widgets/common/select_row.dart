import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'directional_icons.dart';

/// Tappable field-like row that opens a picker.
class SelectRow extends StatelessWidget {
  const SelectRow({super.key, required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: context.scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
          side: BorderSide(color: context.appColors.border),
        ),
        child: InkWell(
          borderRadius: AppRadius.mdAll,
          onTap: onTap,
          child: SizedBox(
            height: AppSizes.fieldHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Text(value, style: context.text.titleMedium),
                  ),
                  Icon(
                    DirectionalIcons.forward(context),
                    size: AppSizes.iconSm,
                    color: context.appColors.mutedText,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
