import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Muted label at the start, bold value at the end.
class LabelValueRow extends StatelessWidget {
  const LabelValueRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.valueStyle,
    this.ltrValue = false,
  });

  final String label;
  final String value;
  final IconData? icon;
  final TextStyle? valueStyle;
  final bool ltrValue;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: context.appColors.mutedText),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              label,
              style: context.text.labelMedium
                  ?.copyWith(color: context.appColors.mutedText),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                textDirection: ltrValue ? TextDirection.ltr : null,
                style: valueStyle ?? context.text.titleSmall,
              ),
            ),
          ],
        ),
      );
}
