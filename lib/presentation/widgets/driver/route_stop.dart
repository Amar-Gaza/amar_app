import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../common/square_icon_button.dart';

/// One stop of a pickup → drop-off route: ring marker, label, place and
/// optional details, with a directions button when [onDirections] is set.
class RouteStop extends StatelessWidget {
  const RouteStop({
    super.key,
    required this.color,
    required this.label,
    required this.place,
    this.details,
    this.onDirections,
    this.directionsLabel,
  });

  final Color color;
  final String label;
  final String place;
  final String? details;
  final VoidCallback? onDirections;
  final String? directionsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Container(
            width: AppSizes.routeDot,
            height: AppSizes.routeDot,
            decoration: BoxDecoration(
              color: context.scheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: AppSizes.routeDotBorder),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    context.text.labelSmall?.copyWith(color: colors.mutedText),
              ),
              Text(place, style: context.text.titleMedium),
              if (details != null && details!.isNotEmpty)
                Text(details!, style: context.text.bodySmall),
            ],
          ),
        ),
        if (onDirections != null)
          SquareIconButton(
            icon: LucideIcons.navigation,
            tone: SquareIconTone.mint,
            tooltip: directionsLabel,
            onPressed: onDirections,
          ),
      ],
    );
  }
}
