import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../common/blinking_dot.dart';

/// Online / offline pill with a small switch; shows a spinner while the
/// status request runs.
class OnlineTogglePill extends StatelessWidget {
  const OnlineTogglePill({
    super.key,
    required this.online,
    required this.busy,
    required this.onToggle,
  });

  static const double _borderAlpha = 0.3;

  final bool online;
  final bool busy;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final foreground = online ? colors.success : colors.mutedText;
    const knobInset =
        (AppSizes.onlineSwitchHeight - AppSizes.onlineSwitchKnob) / 2;
    return Semantics(
      button: true,
      toggled: online,
      label: l10n.driverToggleOnline,
      child: InkWell(
        onTap: busy ? null : onToggle,
        borderRadius: AppRadius.pillAll,
        child: AnimatedContainer(
          duration: AppDurations.dot,
          height: AppSizes.onlinePillHeight,
          padding: const EdgeInsetsDirectional.only(
            start: AppSpacing.md,
            end: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: online ? colors.successSoft : colors.surfaceSoft,
            borderRadius: AppRadius.pillAll,
            border: Border.all(
              color: online
                  ? colors.success.withValues(alpha: _borderAlpha)
                  : colors.border,
              width: AppSizes.borderWidthActive,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlinkingDot(color: foreground, animate: online),
              const SizedBox(width: AppSpacing.sm),
              Text(
                online ? l10n.driverOnline : l10n.driverOffline,
                style: context.text.labelMedium?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (busy)
                SizedBox(
                  width: AppSizes.onlineSwitchWidth,
                  height: AppSizes.onlineSwitchHeight,
                  child: Center(
                    child: SizedBox.square(
                      dimension: AppSizes.onlineSwitchKnob,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSizes.loaderStroke,
                        color: foreground,
                      ),
                    ),
                  ),
                )
              else
                AnimatedContainer(
                  duration: AppDurations.dot,
                  width: AppSizes.onlineSwitchWidth,
                  height: AppSizes.onlineSwitchHeight,
                  padding: const EdgeInsets.all(knobInset),
                  alignment: online
                      ? AlignmentDirectional.centerEnd
                      : AlignmentDirectional.centerStart,
                  decoration: BoxDecoration(
                    color: online ? colors.brandBright : colors.disabled,
                    borderRadius: AppRadius.pillAll,
                  ),
                  child: Container(
                    width: AppSizes.onlineSwitchKnob,
                    height: AppSizes.onlineSwitchKnob,
                    decoration: BoxDecoration(
                      color: context.scheme.surface,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
