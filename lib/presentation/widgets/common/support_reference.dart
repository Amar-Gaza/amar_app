import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Request id the user can quote to support.
class SupportReference extends StatelessWidget {
  const SupportReference({
    super.key,
    required this.label,
    required this.reference,
  });

  final String label;
  final String reference;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: context.appColors.surfaceSoft,
          borderRadius: AppRadius.mdAll,
        ),
        child: Row(
          children: [
            Text(label, style: context.text.labelSmall),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: SelectableText(
                reference,
                textAlign: TextAlign.end,
                textDirection: TextDirection.ltr,
                style: context.text.labelSmall
                    ?.copyWith(color: context.appColors.mutedText),
              ),
            ),
          ],
        ),
      );
}
