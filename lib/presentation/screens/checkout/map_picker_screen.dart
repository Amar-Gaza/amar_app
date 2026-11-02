import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/map_picker_controller.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/localization/location_issue_text.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/catalog/picked_location.dart';
import '../../../data/services/shared/device_location_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/info_banner.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/square_icon_button.dart';
import '../../widgets/common/state_tone.dart';

/// Full map with a fixed center pin; returns the point under it.
class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapPickerController _picker = Get.find<MapPickerController>();
  final Completer<GoogleMapController> _map = Completer();
  late final Worker _follow = ever(_picker.located, _moveTo);

  @override
  void initState() {
    super.initState();
    _follow;
  }

  Future<void> _moveTo(PickedLocation? point) async {
    if (point == null) return;
    final map = await _map.future;
    await map.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(point.lat, point.lng),
        AppDefaults.mapZoom,
      ),
    );
  }

  @override
  void dispose() {
    _follow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final start = _picker.point;
    return Scaffold(
      appBar: AppTopBar(title: l10n.mapPickerTitle),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(start.lat, start.lng),
              zoom: AppDefaults.mapZoom,
            ),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: _map.complete,
            onCameraMove: (camera) => _picker.move(
              camera.target.latitude,
              camera.target.longitude,
            ),
          ),
          // Lifted so the pin's tip, not its middle, marks the point.
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.mapPinSize),
            child: Icon(
              LucideIcons.mapPin,
              size: AppSizes.mapPinSize,
              color: context.appColors.brand,
            ),
          ),
          PositionedDirectional(
            end: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: Obx(
              () => SquareIconButton(
                icon: LucideIcons.locateFixed,
                tooltip: l10n.addressUseMyLocation,
                onPressed: _picker.isLocating.value
                    ? null
                    : _picker.issue.value == LocationIssue.deniedForever
                        ? _picker.openSettings
                        : _picker.locate,
              ),
            ),
          ),
          PositionedDirectional(
            top: AppSpacing.md,
            start: AppSpacing.lg,
            end: AppSpacing.lg,
            child: Obx(() {
              final issue = _picker.issue.value;
              if (issue == null) return const SizedBox.shrink();
              return InfoBanner(
                icon: LucideIcons.mapPin,
                tone: StateTone.warning,
                title: LocationIssueText.of(l10n, issue),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: PrimaryButton(
          label: l10n.mapPickerConfirm,
          onPressed: () => Get.back<PickedLocation>(result: _picker.point),
        ),
      ),
    );
  }
}
