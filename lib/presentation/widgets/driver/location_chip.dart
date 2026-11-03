import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/driver/driver_location_controller.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/services/shared/device_location_service.dart';
import '../../../l10n/app_localizations.dart';
import '../common/state_tone.dart';

/// Compact location-sharing status under the driver home header.
/// Problem states are tappable to retry or open settings.
class LocationChip extends GetView<DriverLocationController> {
  const LocationChip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Obx(() {
      final state = controller.state.value;
      if (state == LocationState.idle) return const SizedBox.shrink();
      final (tone, icon, label) = switch (state) {
        LocationState.sending || LocationState.idle => (
            StateTone.warning,
            null,
            l10n.driverLocationUpdating
          ),
        LocationState.ok => (
            StateTone.success,
            LucideIcons.mapPin,
            l10n.driverLocationUpdated
          ),
        LocationState.permission => (
            StateTone.danger,
            LucideIcons.mapPinOff,
            l10n.driverLocationPermission,
          ),
        LocationState.unavailable => (
            StateTone.warning,
            LucideIcons.mapPinOff,
            l10n.locationServiceOff,
          ),
        LocationState.failed => (
            StateTone.warning,
            LucideIcons.refreshCw,
            l10n.driverLocationFailed,
          ),
      };
      final VoidCallback? onTap = switch (state) {
        LocationState.permission =>
          controller.issue.value == LocationIssue.deniedForever
              ? controller.openSettings
              : controller.sendNow,
        LocationState.unavailable || LocationState.failed => controller.sendNow,
        _ => null,
      };
      final foreground = tone.foreground(colors);
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.pillAll,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: tone.background(colors),
              borderRadius: AppRadius.pillAll,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon == null)
                  SizedBox.square(
                    dimension: AppSizes.iconXs,
                    child: CircularProgressIndicator(
                      strokeWidth: AppSizes.loaderStroke,
                      color: foreground,
                    ),
                  )
                else
                  Icon(icon, size: AppSizes.iconXs, color: foreground),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        context.text.labelMedium?.copyWith(color: foreground),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
