import '../../data/services/shared/device_location_service.dart';
import '../../l10n/app_localizations.dart';

/// User-facing message for a device location problem.
abstract final class LocationIssueText {
  static String of(AppLocalizations l10n, LocationIssue issue) =>
      switch (issue) {
        LocationIssue.serviceDisabled => l10n.locationServiceOff,
        LocationIssue.denied => l10n.locationDenied,
        LocationIssue.deniedForever => l10n.locationDeniedForever,
      };
}
