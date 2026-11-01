import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../common/directional_icons.dart';

/// Round back button floating over a cover image.
class CoverBackButton extends StatelessWidget {
  const CoverBackButton({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: IconButton.filled(
            onPressed: () => Navigator.of(context).maybePop(),
            style: IconButton.styleFrom(
              backgroundColor: context.scheme.surface,
              foregroundColor: context.appColors.ink,
            ),
            icon: Icon(DirectionalIcons.back(context)),
          ),
        ),
      );
}
