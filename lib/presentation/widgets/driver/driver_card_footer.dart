import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../common/dashed_painter.dart';

/// Bottom row of a job card under a dashed rule: a label/value pair on the
/// start side and actions on the end side.
class DriverCardFooter extends StatelessWidget {
  const DriverCardFooter({
    super.key,
    required this.label,
    required this.value,
    this.trailing = const [],
  });

  final String label;
  final String value;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return CustomPaint(
      painter: DashedPainter(color: colors.border),
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.text.labelSmall
                        ?.copyWith(color: colors.mutedText),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.headlineSmall
                        ?.copyWith(color: colors.brand),
                  ),
                ],
              ),
            ),
            for (final widget in trailing) ...[
              const SizedBox(width: AppSpacing.sm),
              widget,
            ],
          ],
        ),
      ),
    );
  }
}
