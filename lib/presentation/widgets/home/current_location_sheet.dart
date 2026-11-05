import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/localization/location_issue_text.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/services/shared/device_location_service.dart';
import '../../../l10n/app_localizations.dart';

abstract final class CurrentLocationSheet {
  static Future<void> show(BuildContext context, AppLocalizations l10n) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => _CurrentLocationSheet(l10n: l10n),
      );
}

class _CurrentLocationSheet extends StatefulWidget {
  const _CurrentLocationSheet({required this.l10n});

  final AppLocalizations l10n;

  @override
  State<_CurrentLocationSheet> createState() => _CurrentLocationSheetState();
}

class _CurrentLocationSheetState extends State<_CurrentLocationSheet> {
  bool _loading = false;
  bool _addressUnavailable = false;
  LocationIssue? _issue;

  Future<void> _locate() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _issue = null;
      _addressUnavailable = false;
    });
    try {
      await Get.find<DeviceLocationService>().currentAddress();
      if (mounted) Navigator.pop(context);
    } on LocationException catch (error) {
      if (mounted) setState(() => _issue = error.issue);
    } on LocationAddressException {
      if (mounted) setState(() => _addressUnavailable = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final settingsNeeded = _issue == LocationIssue.deniedForever ||
        _issue == LocationIssue.serviceDisabled;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.page),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.locationTitle,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.locationSubtitle),
            if (_issue != null || _addressUnavailable) ...[
              const SizedBox(height: AppSpacing.md),
              Text(_addressUnavailable
                  ? l10n.locationAddressUnavailable
                  : LocationIssueText.of(l10n, _issue!)),
            ],
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: _loading ? null : _locate,
              icon: _loading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
              label: Text(
                  _loading ? l10n.addressLocating : l10n.locationUseCurrent),
            ),
            if (settingsNeeded)
              TextButton(
                onPressed: () {
                  final service = Get.find<DeviceLocationService>();
                  if (_issue == LocationIssue.serviceDisabled) {
                    service.openLocationSettings();
                  } else {
                    service.openSettings();
                  }
                },
                child: Text(l10n.locationOpenSettings),
              ),
          ],
        ),
      ),
    );
  }
}
