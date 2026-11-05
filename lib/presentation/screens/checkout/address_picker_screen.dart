
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/routes/route_args.dart';
import '../../../controllers/customer/checkout_controller.dart';
import '../../../controllers/customer/map_picker_controller.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/localization/location_issue_text.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/catalog/picked_location.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../data/services/shared/device_location_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/primary_button.dart';

class AddressPickerScreen extends StatefulWidget {
  const AddressPickerScreen({super.key});

  @override
  State<AddressPickerScreen> createState() =>
      _AddressPickerScreenState();
}

class _AddressPickerScreenState
    extends State<AddressPickerScreen> {
  final CheckoutController _checkout =
  Get.find<CheckoutController>();

  final DeviceLocationService _location =
  Get.find<DeviceLocationService>();

  final TextEditingController _search =
  TextEditingController();

  late final String _tag =
      'delivery-point-${identityHashCode(this)}';

  late final MapPickerController _picker;
  late final Worker _follow;
  late PickedLocation _cameraPoint;

  GoogleMapController? _map;

  bool _addingAddress = false;
  bool _searching = false;
  String? _searchError;

  @override
  void initState() {
    super.initState();

    final saved = _checkout.address.value;
    final devicePoint = _location.currentPoint.value;

    final withinGaza = devicePoint != null &&
        devicePoint.lat >= 31.20 &&
        devicePoint.lat <= 31.63 &&
        devicePoint.lng >= 34.15 &&
        devicePoint.lng <= 34.62;

    final PickedLocation? initial = saved != null
        ? PickedLocation(
      lat: saved.lat,
      lng: saved.lng,
    )
        : (withinGaza ? devicePoint : null);

    _picker = Get.put<MapPickerController>(
      MapPickerController(
        _location,
        initial,
        autoLocate: false,
      ),
      tag: _tag,
    );

    _cameraPoint = _picker.point;

    _checkout.deliveryLocationFailure.value = null;

    _follow = ever<PickedLocation?>(
      _picker.located,
          (point) {
        if (point != null) {
          unawaited(_moveTo(point));
        }
      },
    );
  }

  Future<void> _moveTo(PickedLocation point) async {
    if (!mounted) return;

    _cameraPoint = point;
    _picker.setPoint(point);

    final map = _map;
    if (map == null) return;

    try {
      await map.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(point.lat, point.lng),
          AppDefaults.mapZoom,
        ),
      );
    } catch (_) {
      // Map may be disposed during navigation.
    }
  }

  void _cameraMoved(CameraPosition position) {
    _cameraPoint = PickedLocation(
      lat: position.target.latitude,
      lng: position.target.longitude,
    );
  }

  void _cameraIdle() {
    if (!mounted) return;

    // Save the center point after moving the map.
    _picker.setPoint(_cameraPoint);

    _checkout.deliveryLocationFailure.value = null;
  }

  static bool _isInGaza(Location location) {
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
      Location? match;

      final candidates = [
        '$query, قطاع غزة، فلسطين',
        '$query, Gaza Strip, Palestine',
      ];

      for (final text in candidates) {
        try {
          final results = await locationFromAddress(text);

          for (final result in results) {
            if (_isInGaza(result)) {
              match = result;
              break;
            }
          }

          if (match != null) break;
        } catch (_) {
          // Try another search spelling.
        }
      }

      if (!mounted) return;

      if (match == null) {
        setState(() {
          _searchError =
          'لم نجد هذا الموقع داخل قطاع غزة. '
              'جرّب اسم حي أو شارع آخر.';
        });
        return;
      }

      await _moveTo(
        PickedLocation(
          lat: match.latitude,
          lng: match.longitude,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _searching = false);
      }
    }
  }

  void _showSelectPointHint() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'حرّك الخريطة أو ابحث عن موقع أولًا.',
        ),
      ),
    );
  }

  Future<void> _addAddress() async {
    if (_addingAddress ||
        _checkout.isSavingDeliveryLocation.value) {
      return;
    }

    if (!_picker.canConfirm) {
      _showSelectPointHint();
      return;
    }

    setState(() => _addingAddress = true);

    try {
      // Pass the selected map coordinates
      // to the new address form.
      final saved = await Get.toNamed<Address>(
        AppRoutes.checkoutAddressNew,
        arguments: AddressFormArgs(
          point: _picker.point,
        ),
      );

      if (!mounted || saved == null) return;

      _checkout.addAddress(saved);

      await _moveTo(
        PickedLocation(
          lat: saved.lat,
          lng: saved.lng,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _addingAddress = false);
      }
    }
  }

  Future<void> _confirm() async {
    if (_addingAddress ||
        _checkout.isSavingDeliveryLocation.value) {
      return;
    }

    if (!_picker.canConfirm) {
      _showSelectPointHint();
      return;
    }

    final point = _picker.point;
    final resolved = _picker.address.value;
    final current = _checkout.address.value;

    Address? saved = current != null &&
        current.lat == point.lat &&
        current.lng == point.lng
        ? current
        : _checkout.addresses.firstWhereOrNull(
          (item) =>
      item.lat == point.lat &&
          item.lng == point.lng,
    );

    if (saved == null) {
      final resolvedLabel =
          resolved?.label.trim() ?? '';

      final label = resolvedLabel.isEmpty
          ? AppLocalizations.of(context).deliveryAddress
          : resolvedLabel;

      saved = await _checkout.saveDeliveryLocation(
        point: point,
        label: String.fromCharCodes(
          label.runes.take(
            AppDefaults.addressLabelMax,
          ),
        ),
        details: resolved?.label,
      );
    } else {
      _checkout.selectAddress(saved);
    }

    if (!mounted || saved == null) return;

    _checkout.selectAddress(saved);

    _location.currentPoint.value = PickedLocation(
      lat: saved.lat,
      lng: saved.lng,
    );

    Get.back<void>();
  }

  @override
  void dispose() {
    _follow.dispose();
    _search.dispose();

    Get.delete<MapPickerController>(
      tag: _tag,
    );

    _map?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final initial = _picker.point;

    return Scaffold(
      appBar: AppTopBar(
        title: l10n.addressPickerTitle,
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  // Full-width interactive map.
                  Positioned.fill(
                    child: Obx(
                          () => AbsorbPointer(
                        absorbing: _checkout
                            .isSavingDeliveryLocation.value,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              initial.lat,
                              initial.lng,
                            ),
                            zoom: AppDefaults.mapZoom,
                          ),
                          onMapCreated: (map) {
                            _map = map;

                            final gpsPoint =
                                _picker.located.value;

                            if (gpsPoint != null) {
                              unawaited(_moveTo(gpsPoint));
                            }
                          },
                          onCameraMoveStarted:
                          _picker.beginManualSelection,
                          onCameraMove: _cameraMoved,
                          onCameraIdle: _cameraIdle,
                          onTap: (point) {
                            unawaited(
                              _moveTo(
                                PickedLocation(
                                  lat: point.latitude,
                                  lng: point.longitude,
                                ),
                              ),
                            );
                          },
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                        ),
                      ),
                    ),
                  ),

                  // Fixed center marker.
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Center(
                        child: Transform.translate(
                          offset: const Offset(0, -22),
                          child: const Icon(
                            Icons.location_pin,
                            size: 50,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Gaza location search.
                  PositionedDirectional(
                    top: AppSpacing.md,
                    start: AppSpacing.lg,
                    end: AppSpacing.lg,
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                        children: [
                          Material(
                            elevation: 3,
                            color: context.scheme.surface,
                            borderRadius: AppRadius.lgAll,
                            child: TextField(
                              controller: _search,
                              textInputAction:
                              TextInputAction.search,
                              onSubmitted: (_) {
                                unawaited(_searchPlace());
                              },
                              decoration: InputDecoration(
                                hintText:
                                'ابحث عن منطقة أو شارع في قطاع غزة',
                                prefixIcon: const Icon(
                                  LucideIcons.search,
                                ),
                                suffixIcon: _searching
                                    ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox.square(
                                    dimension: 18,
                                    child:
                                    CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                                    : IconButton(
                                  icon: const Icon(
                                    LucideIcons.search,
                                  ),
                                  onPressed: _searchPlace,
                                ),
                              ),
                            ),
                          ),

                          if (_searchError != null)
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 8),
                              child: Material(
                                color: context.scheme.surface,
                                borderRadius: AppRadius.lgAll,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.all(12),
                                  child: Text(_searchError!),
                                ),
                              ),
                            ),

                          const SizedBox(
                            height: AppSpacing.sm,
                          ),

                          // Selected address information.
                          Obx(() {
                            final issue = _picker.issue.value;

                            return Material(
                              color: context.scheme.surface,
                              borderRadius: AppRadius.lgAll,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  AppSpacing.md,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      _picker.address.value?.label ??
                                          (_picker.isResolving.value
                                              ? l10n.addressLocating
                                              : l10n.addressPickOnMap),
                                      style: context.text.titleSmall,
                                    ),

                                    if (_picker.hasSelection.value)
                                      Text(
                                        '${_picker.point.lat.toStringAsFixed(6)}, '
                                            '${_picker.point.lng.toStringAsFixed(6)}',
                                        textDirection:
                                        TextDirection.ltr,
                                        style: context.text.labelSmall,
                                      ),

                                    if (_picker
                                        .addressUnavailable.value)
                                      Text(
                                        l10n.locationAddressUnavailable,
                                      ),

                                    if (issue != null)
                                      Text(
                                        LocationIssueText.of(
                                          l10n,
                                          issue,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Current GPS position button.
                  PositionedDirectional(
                    end: AppSpacing.lg,
                    bottom: AppSpacing.lg,
                    child: SizedBox(
                      width: 200,
                      height: 56,
                      child: Obx(
                            () => FilledButton.icon(
                          onPressed: _picker.isLocating.value
                              ? null
                              : _picker.issue.value ==
                              LocationIssue.deniedForever
                              ? _picker.openSettings
                              : _picker.issue.value ==
                              LocationIssue.serviceDisabled
                              ? _picker.openLocationSettings
                              : _picker.locate,
                          icon: const Icon(
                            LucideIcons.locateFixed,
                            size: 20,
                          ),
                          label: Text(
                            l10n.addressUseMyLocation,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Saved addresses.
          Obx(() {
            if (_checkout.addresses.isEmpty) {
              return const SizedBox.shrink();
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
              ),
              child: Row(
                children: [
                  for (final item in _checkout.addresses)
                    Padding(
                      padding:
                      const EdgeInsetsDirectional.only(
                        end: AppSpacing.sm,
                      ),
                      child: ChoiceChip(
                        label: Text(
                          item.label ?? l10n.addressUse,
                        ),
                        selected: _picker.hasSelection.value &&
                            item.lat == _picker.point.lat &&
                            item.lng == _picker.point.lng,
                        onSelected: _checkout
                            .isSavingDeliveryLocation.value
                            ? null
                            : (_) {
                          unawaited(
                            _moveTo(
                              PickedLocation(
                                lat: item.lat,
                                lng: item.lng,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          }),

          // Add another address.
          Obx(
                () => TextButton.icon(
              onPressed: _checkout
                  .isSavingDeliveryLocation.value ||
                  _addingAddress
                  ? null
                  : _addAddress,
              icon: const Icon(
                LucideIcons.plus,
              ),
              label: Text(l10n.addressAddNew),
            ),
          ),

          Obx(() {
            final failure =
                _checkout.addressesFailure.value;

            if (failure == null) {
              return const SizedBox.shrink();
            }

            return ErrorBanner(failure: failure);
          }),

          Obx(() {
            final failure =
                _checkout.deliveryLocationFailure.value;

            if (failure == null) {
              return const SizedBox.shrink();
            }

            return ErrorBanner(failure: failure);
          }),
        ],
      ),

      bottomNavigationBar: BottomActionBar(
        child: Obx(
              () => PrimaryButton(
            label: l10n.addressUse,
            isLoading:
            _checkout.isSavingDeliveryLocation.value,
            onPressed: _addingAddress ||
                _checkout.isSavingDeliveryLocation.value
                ? null
                : _confirm,
          ),
        ),
      ),
    );
  }
}
