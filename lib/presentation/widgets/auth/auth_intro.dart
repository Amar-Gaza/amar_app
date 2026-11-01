import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../common/icon_tile.dart';
import '../common/state_tone.dart';

/// Icon tile, title and subtitle at the top of auth forms.
class AuthIntro extends StatelessWidget {
  const AuthIntro({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.tone = StateTone.brand,
    this.centered = false,
    this.below,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final StateTone tone;
  final bool centered;
  final Widget? below;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final align = centered ? TextAlign.center : TextAlign.start;
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        IconTile(
          icon: icon,
          background: tone.background(colors),
          foreground: tone.foreground(colors),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(title, textAlign: align, style: context.text.headlineMedium),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(subtitle!, textAlign: align, style: context.text.bodySmall),
        ],
        if (below != null) below!,
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
