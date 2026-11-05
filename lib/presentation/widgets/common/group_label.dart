import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Small muted heading that groups list rows ("Today", "Yesterday").
class GroupLabel extends StatelessWidget {
  const GroupLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xs,
          AppSpacing.lg,
          AppSpacing.xs,
          AppSpacing.sm,
        ),
        child: Text(
          label,
          style: context.text.labelMedium?.copyWith(
            color: context.appColors.mutedText,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
}
