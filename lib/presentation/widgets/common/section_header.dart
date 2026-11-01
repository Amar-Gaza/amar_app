import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'link_button.dart';

/// Section title with an optional subtitle and a trailing action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.text.headlineSmall),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: context.text.labelSmall
                            ?.copyWith(color: context.appColors.mutedText)),
                ],
              ),
            ),
            if (actionLabel != null)
              LinkButton(label: actionLabel!, onPressed: onAction),
          ],
        ),
      );
}
