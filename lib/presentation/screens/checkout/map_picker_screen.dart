
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/map_picker_controller.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/localization/location_issue_text.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/catalog/picked_location.dart';
import '../../../data/services/shared/device_location_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/info_banner.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/square_icon_button.dart';
import '../../widgets/common/state_tone.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() =>
      _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapPickerController _picker =
  Get.find<MapPickerController>();

  final TextEditingController _search =
  TextEditingController();

  GoogleMapController? _map;
  late final Worker _gpsWorker;
  late PickedLocation _selected;

  bool _searching = false;
  String? _searchError;

  @override
  void initState() {
    super.initState();

    _selected = _picker.point;

    _gpsWorker = ever<PickedLocation?>(
      _picker.located,
          (point) {
        if (point != null) {
          _moveTo(point);
        }
      },
    );
  }

  void _onCameraMove(CameraPosition camera) {
    _selected = PickedLocation(
      lat: camera.target.latitude,
      lng: camera.target.longitude,
    );
  }

  void _onCameraIdle() {
    _picker.setPoint(_selected);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _moveTo(PickedLocation point) async {
    _selected = point;
    _picker.setPoint(point);

    if (mounted) {
      setState(() {});
    }

    final map = _map;
    if (map == null) return;

    await map.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(point.lat, point.lng),
        AppDefaults.mapZoom,
      ),
    );
  }

  // Search bounding box for the Gaza Strip.
  // The backend checks the actual delivery service polygon.
  bool _inGaza(Location location) {
    return location.latitude >= 31.20 &&
        location.latitude <= 31.63 &&
        location.longitude >= 34.15 &&
        location.longitude <= 34.62;
  }

  Future<void> _searchPlace() async {
    final query = _search.text.trim();

    if (query.isEmpty || _searching) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _searching = true;
      _searchError = null;
    });

    try {
      Location? found;

      final candidates = <String>[
        '$query, قطاع غزة، فلسطين',
        '$query, Gaza Strip, Palestine',
        query,
      ];

      for (final candidate in candidates) {
        try {
          final results = await locationFromAddress(
            candidate,
          );

          for (final result in results) {
            if (_inGaza(result)) {
              found = result;
              break;
            }
          }

          if (found != null) break;
        } catch (_) {
          // Try another spelling.
        }
      }

      if (found == null) {
        if (mounted) {
          setState(() {
            _searchError =
            'لم نعثر على الموقع داخل قطاع غزة. '
                'جرّب اسم شارع أو حي آخر.';
          });
        }
        return;
      }

      if (!mounted) return;

      await _moveTo(
        PickedLocation(
          lat: found.latitude,
          lng: found.longitude,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _searching = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _gpsWorker.dispose();
    _search.dispose();
    _map?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppTopBar(
        title: l10n.mapPickerTitle,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _selected.lat,
                _selected.lng,
              ),
              zoom: AppDefaults.mapZoom,
            ),
            onMapCreated: (controller) {
              _map = controller;

              final gpsPoint = _picker.located.value;

              if (gpsPoint != null) {
                _moveTo(gpsPoint);
              }
            },
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            onTap: (point) {
              _moveTo(
                PickedLocation(
                  lat: point.latitude,
                  lng: point.longitude,
                ),
              );
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          // Fixed center pin. The map moves underneath it.
          IgnorePointer(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 48,
              ),
            ),
          ),

          // Search field.
          PositionedDirectional(
            top: AppSpacing.md,
            start: AppSpacing.lg,
            end: AppSpacing.lg,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Material(
                    elevation: 3,
                    borderRadius:
                    BorderRadius.circular(14),
                    child: TextField(
                      controller: _search,
                      textInputAction:
                      TextInputAction.search,
                      onSubmitted: (_) =>
                          _searchPlace(),
                      decoration: InputDecoration(
                        hintText:
                        'ابحث عن شارع أو منطقة في قطاع غزة',
                        prefixIcon: const Icon(
                          LucideIcons.search,
                        ),
                        suffixIcon: IconButton(
                          onPressed: _searching
                              ? null
                              : _searchPlace,
                          icon: _searching
                              ? const SizedBox.square(
                            dimension: 20,
                            child:
                            CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                              : const Icon(
                            LucideIcons.arrowLeft,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),

                  if (_searchError != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.sm,
                      ),
                      child: Material(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(10),
                        child: Padding(
                          padding:
                          const EdgeInsets.all(
                            AppSpacing.sm,
                          ),
                          child: Text(
                            _searchError!,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Return to current GPS position.
          PositionedDirectional(
            bottom: AppSpacing.lg,
            end: AppSpacing.lg,
            child: Obx(
                  () => SquareIconButton(
                icon: LucideIcons.locateFixed,
                tooltip: l10n.addressUseMyLocation,
                onPressed:
                _picker.isLocating.value
                    ? null
                    : _picker.issue.value ==
                    LocationIssue.deniedForever
                    ? _picker.openSettings
                    : _picker.issue.value ==
                    LocationIssue
                        .serviceDisabled
                    ? _picker
                    .openLocationSettings
                    : _picker.locate,
              ),
            ),
          ),

          // Actual chosen coordinates.
          PositionedDirectional(
            bottom: AppSpacing.lg,
            start: AppSpacing.lg,
            child: Material(
              elevation: 2,
              borderRadius:
              BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(
                  AppSpacing.sm,
                ),
                child: Text(
                  '${_selected.lat.toStringAsFixed(6)}, '
                      '${_selected.lng.toStringAsFixed(6)}',
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
          ),

          PositionedDirectional(
            top: 84,
            start: AppSpacing.lg,
            end: AppSpacing.lg,
            child: Obx(() {
              final issue = _picker.issue.value;

              if (issue == null) {
                return const SizedBox.shrink();
              }

              return InfoBanner(
                icon: LucideIcons.mapPin,
                tone: StateTone.warning,
                title: LocationIssueText.of(
                  l10n,
                  issue,
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: PrimaryButton(
          label: l10n.mapPickerConfirm,
          onPressed: () {
            Get.back<PickedLocation>(
              result: _selected,
            );
          },
        ),
      ),
    );
  }
}
