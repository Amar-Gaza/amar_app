import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Bordered block with a title, used across order screens.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.children,
    this.title,
    this.trailing,
    this.color,
  });

  final String? title;
  final Widget? trailing;
  final List<Widget> children;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: color,
          borderRadius: AppRadius.cardAll,
          border: Border.all(color: context.appColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(title!, style: context.text.titleMedium),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              const Divider(height: AppSpacing.xl),
            ],
            ...children,
          ],
        ),
      );
}
