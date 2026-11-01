import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Search entry on home; opens the search screen when tapped.
class HomeSearchField extends StatelessWidget {
  const HomeSearchField({super.key, required this.hint, this.onTap});

  final String hint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Material(
        color: context.scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
          side: BorderSide(color: colors.border),
        ),
        child: InkWell(
          borderRadius: AppRadius.mdAll,
          onTap: onTap,
          child: SizedBox(
            height: AppSizes.fieldHeight,
            child: Row(
              children: [
                const SizedBox(width: AppSpacing.lg),
                Icon(LucideIcons.search,
                    size: AppSizes.iconSm, color: colors.mutedText),
                const SizedBox(width: AppSpacing.md),
                Text(
                  hint,
                  style: context.text.bodyMedium
                      ?.copyWith(color: colors.mutedText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
