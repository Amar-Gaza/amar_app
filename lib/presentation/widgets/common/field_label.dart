import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Bold label placed above a form field.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(
          start: AppSpacing.xs,
          bottom: AppSpacing.xs,
        ),
        child: Text(text, style: context.text.titleSmall),
      );
}
