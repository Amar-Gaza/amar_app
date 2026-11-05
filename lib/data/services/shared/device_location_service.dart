import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_defaults.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/app_preferences.dart';
import '../../models/catalog/picked_location.dart';

enum LocationIssue {
  serviceDisabled,
  denied,
  deniedForever,
  unavailable,
}

class LocationException implements Exception {
  const LocationException(this.issue);

  final LocationIssue issue;
}

class ResolvedLocation {
  const ResolvedLocation({
    required this.point,
    required this.city,
    required this.neighborhood,
    required this.street,
    required this.buildingNumber,
    required this.languageCode,
  });

  final PickedLocation point;
  final String city;
  final String neighborhood;
  final String street;
  final String buildingNumber;
  final String languageCode;

  String get label {
    final parts = languageCode == 'ar'
        ? [
      city,
      neighborhood,
      street,
      buildingNumber,
    ]
        : [
      city,
      neighborhood,
      buildingNumber,
      street,
    ];

    return parts
        .where((part) => part.isNotEmpty)
        .toSet()
        .join(languageCode == 'ar' ? '، ' : ', ');
  }
}

class LocationAddressException implements Exception {}

/// GPS fixes and address previews are independent
/// of the confirmed customer location.
class DeviceLocationService {
  DeviceLocationService({
    AppPreferences? preferences,
  }) : _preferences = preferences {
    _customerId = preferences?.activeCustomerId;

    languageCode.value =
        preferences?.locale ?? AppDefaults.defaultLocale;

    _restore();
  }

  final AppPreferences? _preferences;

  int? _customerId;

  final Map<String, ResolvedLocation> _savedAddresses = {};

  final Rxn<PickedLocation> currentPoint =
  Rxn<PickedLocation>();

  final Rxn<ResolvedLocation> resolvedLocation =
  Rxn<ResolvedLocation>();

  final RxString languageCode =
      AppDefaults.defaultLocale.obs;

  final RxBool isLocating = false.obs;
  final RxBool addressUnavailable = false.obs;

  final Rxn<LocationIssue> issue = Rxn<LocationIssue>();

  bool _manualSelection = false;

  int _selectionVersion = 0;

  Future<void> _geocodeQueue = Future<void>.value();

  void activateCustomer(int? customerId) {
    if (_customerId == customerId) return;

    _customerId = customerId;

    _restore();
  }

  void _restore() {
    // Invalidate GPS/geocoder completions
    // from the previous account.
    ++_selectionVersion;

    currentPoint.value = null;
    resolvedLocation.value = null;

    _savedAddresses.clear();
    _manualSelection = false;

    issue.value = null;
    addressUnavailable.value = false;
    isLocating.value = false;

    final snapshot = _preferences?.customerState(
      StorageKeys.customerLocation,
      customerId: _customerId,
    );

    if (snapshot == null || snapshot['schema'] != 1) {
      return;
    }

    final lat = snapshot['lat'];
    final lng = snapshot['lng'];

    if (lat is! num ||
        lng is! num ||
        !lat.isFinite ||
        !lng.isFinite ||
        lat < -90 ||
        lat > 90 ||
        lng < -180 ||
        lng > 180) {
      return;
    }

    final point = PickedLocation(
      lat: lat.toDouble(),
      lng: lng.toDouble(),
    );

    currentPoint.value = point;
    _manualSelection = snapshot['manual'] == true;

    final addresses = snapshot['addresses'];

    if (addresses is Map) {
      for (final entry in addresses.entries) {
        final raw = entry.value;

        if (entry.key is! String || raw is! Map) {
          continue;
        }

        if ([
          'city',
          'neighborhood',
          'street',
          'building_number',
        ].any((key) => raw[key] is! String)) {
          continue;
        }

        final address = ResolvedLocation(
          point: point,
          city: raw['city'] as String,
          neighborhood: raw['neighborhood'] as String,
          street: raw['street'] as String,
          buildingNumber: raw['building_number'] as String,
          languageCode: entry.key as String,
        );

        if (address.label.isNotEmpty) {
          _savedAddresses[address.languageCode] = address;
        }
      }
    }

    resolvedLocation.value =
    _savedAddresses[languageCode.value];

    addressUnavailable.value =
        resolvedLocation.value == null;
  }

  void _persist() {
    final preferences = _preferences;
    final point = currentPoint.value;

    if (preferences == null || point == null) return;

    unawaited(
      preferences.saveCustomerState(
        StorageKeys.customerLocation,
        {
          'schema': 1,
          'lat': point.lat,
          'lng': point.lng,
          'manual': _manualSelection,
          'addresses': {
            for (final entry in _savedAddresses.entries)
              entry.key: {
                'city': entry.value.city,
                'neighborhood': entry.value.neighborhood,
                'street': entry.value.street,
                'building_number':
                entry.value.buildingNumber,
              },
          },
        },
        customerId: _customerId,
      ),
    );
  }

  void _rememberAddress(ResolvedLocation address) {
    final point = currentPoint.value;

    if (point == null ||
        address.point.lat != point.lat ||
        address.point.lng != point.lng) {
      return;
    }

    _savedAddresses[address.languageCode] = address;

    resolvedLocation.value = address;
    addressUnavailable.value = false;

    _persist();
  }

  Future<Position> current() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw const LocationException(
          LocationIssue.serviceDisabled,
        );
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        throw const LocationException(
          LocationIssue.deniedForever,
        );
      }

      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw const LocationException(
          LocationIssue.denied,
        );
      }

      try {
        return await _position(
          LocationAccuracy.bestForNavigation,
        );
      } catch (_) {
        // This explicit GPS action requests a fresh fix.
        return await _position(
          LocationAccuracy.high,
        );
      }
    } on LocationException {
      rethrow;
    } catch (_) {
      throw const LocationException(
        LocationIssue.unavailable,
      );
    }
  }

  Future<Position> _position(
      LocationAccuracy accuracy,
      ) =>
      Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: AppDurations.locationFix,
        ),
      ).timeout(AppDurations.locationFix);

  Future<bool> openSettings() =>
      Geolocator.openAppSettings();

  Future<bool> openLocationSettings() =>
      Geolocator.openLocationSettings();

  void confirmPoint(
      PickedLocation point, {
        ResolvedLocation? address,
      }) {
    ++_selectionVersion;
    _manualSelection = true;

    final previous = currentPoint.value;

    if (previous?.lat != point.lat ||
        previous?.lng != point.lng) {
      _savedAddresses.clear();
    }

    currentPoint.value = point;

    resolvedLocation.value =
    address != null &&
        address.point.lat == point.lat &&
        address.point.lng == point.lng &&
        address.languageCode == languageCode.value
        ? address
        : _savedAddresses[languageCode.value];

    final resolved = resolvedLocation.value;

    if (resolved != null) {
      _savedAddresses[resolved.languageCode] = resolved;
    }

    issue.value = null;
    addressUnavailable.value =
        resolvedLocation.value == null;

    isLocating.value = false;

    _persist();
  }

  Future<void> setLanguage(String value) async {
    languageCode.value = value;

    final point = currentPoint.value;
    final version = _selectionVersion;

    if (point == null) return;

    final cached = _savedAddresses[value];

    if (cached != null) {
      resolvedLocation.value = cached;
      addressUnavailable.value = false;
      return;
    }

    resolvedLocation.value = null;

    try {
      final address = await resolveAddress(point);

      if (version == _selectionVersion &&
          address.languageCode == languageCode.value) {
        _rememberAddress(address);
      }
    } on LocationAddressException {
      if (version == _selectionVersion &&
          value == languageCode.value &&
          resolvedLocation.value == null) {
        addressUnavailable.value = true;
      }
    }
  }

  Future<void> refreshCurrentAddress() async {
    // Use the saved confirmed point on startup.
    // Only an explicit current-location action
    // requests GPS again.
    if (currentPoint.value != null) {
      if (resolvedLocation.value == null) {
        await setLanguage(languageCode.value);
      }

      return;
    }

    if (isLocating.value) return;

    try {
      await currentAddress();
    } on LocationException {
      // Home exposes the issue and retry/settings action.
    } on LocationAddressException {
      // Coordinates remain valid if no address is returned.
    }
  }

  Future<ResolvedLocation> currentAddress() async {
    final version = ++_selectionVersion;

    isLocating.value = true;
    issue.value = null;

    try {
      final position = await current();

      final point = PickedLocation(
        lat: position.latitude,
        lng: position.longitude,
      );

      if (version == _selectionVersion) {
        _manualSelection = false;

        currentPoint.value = point;
        resolvedLocation.value = null;

        _savedAddresses.clear();
        addressUnavailable.value = false;

        // Save coordinates even if geocoding is offline.
        _persist();
      }

      final address = await resolveAddress(point);

      if (version == _selectionVersion) {
        _rememberAddress(address);
      }

      return address;
    } on LocationException catch (error) {
      if (version == _selectionVersion) {
        issue.value = error.issue;
      }

      rethrow;
    } on LocationAddressException {
      if (version == _selectionVersion &&
          resolvedLocation.value == null) {
        addressUnavailable.value = true;
      }

      rethrow;
    } finally {
      if (version == _selectionVersion) {
        isLocating.value = false;
      }
    }
  }

  /// Pure preview: does not change confirmed coordinates.
  Future<ResolvedLocation> resolveAddress(
      PickedLocation point,
      ) async {
    final language = languageCode.value;

    // The native geocoder locale is global.
    // Serialize calls across screens.
    final task = _geocodeQueue.then(
          (_) => _reverse(point, language),
    );

    _geocodeQueue = task.then<void>(
          (_) {},
      onError: (Object _, StackTrace __) {},
    );

    final result = await task;

    if (language != languageCode.value) {
      return resolveAddress(point);
    }

    return result;
  }

  Future<ResolvedLocation> _reverse(
      PickedLocation point,
      String language,
      ) async {
    try {
      await setLocaleIdentifier(
        language == 'ar' ? 'ar_PS' : 'en_US',
      ).timeout(AppDurations.locationGeocode);

      final places = await placemarkFromCoordinates(
        point.lat,
        point.lng,
      ).timeout(AppDurations.locationGeocode);

      // Plus Codes must not be displayed as street names.
      final plusCode = RegExp(
        r'[23456789CFGHJMPQRVWX]{2,8}\+[23456789CFGHJMPQRVWX]{2,3}',
        caseSensitive: false,
      );

      String clean(String? value) =>
          (value ?? '').replaceAll(plusCode, '').trim();

      String first(List<String?> values) => values
          .map(clean)
          .firstWhere(
            (value) => value.isNotEmpty,
        orElse: () => '',
      );

      ResolvedLocation? best;
      var bestScore = -1;

      for (final place in places) {
        final candidate = ResolvedLocation(
          point: point,
          city: first([
            place.locality,
            place.subAdministrativeArea,
            place.administrativeArea,
          ]),
          neighborhood: clean(place.subLocality),
          street: first([
            place.thoroughfare,
            place.street,
          ]),
          buildingNumber: clean(place.subThoroughfare),
          languageCode: language,
        );

        final score =
            (candidate.city.isNotEmpty ? 1 : 0) +
                (candidate.neighborhood.isNotEmpty ? 2 : 0) +
                (candidate.street.isNotEmpty ? 4 : 0);

        if (score > bestScore &&
            candidate.label.isNotEmpty) {
          best = candidate;
          bestScore = score;
        }
      }

      if (best == null) {
        throw LocationAddressException();
      }

      return best;
    } on LocationAddressException {
      rethrow;
    } catch (_) {
      throw LocationAddressException();
    }
  }
}