import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/driver/driver_location_controller.dart';
import '../../../core/localization/error_message_resolver.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/services/shared/device_location_service.dart';
import '../../../l10n/app_localizations.dart';
import '../common/info_banner.dart';
import '../common/state_tone.dart';

/// Location sharing health (designs 06, 07, 23–25).
class LocationStatusCard extends GetView<DriverLocationController> {
  const LocationStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return Obx(() {
      final last = controller.lastSent.value;
      switch (controller.state.value) {
        case LocationState.idle:
          return const SizedBox.shrink();
        case LocationState.sending:
          return InfoBanner(
            icon: LucideIcons.locateFixed,
            tone: StateTone.brand,
            title: l10n.driverLocationSending,
          );
        case LocationState.ok:
          return InfoBanner(
            icon: LucideIcons.circleCheck,
            tone: StateTone.success,
            title: l10n.driverLocationOk,
            message: last == null
                ? null
                : l10n.driverLocationLast(
                    DateFormatter.dayMonthTime(last, locale),
                  ),
          );
        case LocationState.permission:
          return InkWell(
            onTap: controller.issue.value == LocationIssue.deniedForever
                ? controller.openSettings
                : controller.sendNow,
            child: InfoBanner(
              icon: LucideIcons.mapPinOff,
              tone: StateTone.danger,
              title: l10n.driverLocationPermission,
              message: l10n.driverLocationPermissionHint,
            ),
          );
        case LocationState.unavailable:
          return InkWell(
            onTap: controller.sendNow,
            child: InfoBanner(
              icon: LucideIcons.mapPinOff,
              tone: StateTone.warning,
              title: l10n.locationServiceOff,
            ),
          );
        case LocationState.failed:
          final failure = controller.failure.value;
          return InkWell(
            onTap: controller.sendNow,
            child: InfoBanner(
              icon: LucideIcons.refreshCw,
              tone: StateTone.warning,
              title: l10n.driverLocationFailed,
              message: failure == null
                  ? null
                  : ErrorMessageResolver.resolve(failure, l10n),
            ),
          );
      }
    });
  }
}
