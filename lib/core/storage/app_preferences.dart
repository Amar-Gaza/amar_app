import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/app_defaults.dart';
import '../constants/storage_keys.dart';

class AppPreferences {
  AppPreferences(this._box);

  final GetStorage _box;

  static Future<AppPreferences> init() async {
    await GetStorage.init();
    return AppPreferences(GetStorage());
  }

  String get locale =>
      _box.read<String>(StorageKeys.locale) ?? AppDefaults.defaultLocale;

  Future<void> setLocale(String value) => _box.write(StorageKeys.locale, value);

  int? get activeCustomerId {
    final value = _box.read<Object>(
      StorageKeys.activeCustomerId,
    );

    return value is int && value > 0 ? value : null;
  }

  Future<void> setActiveCustomerId(int? value) => _writeLocal(
        () => value == null
            ? _box.remove(StorageKeys.activeCustomerId)
            : _box.write(
                StorageKeys.activeCustomerId,
                value,
              ),
      );

  String _customerKey(String key, int? customerId) =>
      '$key.${customerId ?? 'guest'}';

  /// Snapshots contain JSON primitives only.
  /// Damaged caches are discarded.
  Map<String, dynamic>? customerState(
    String key, {
    required int? customerId,
  }) {
    try {
      final raw = _box.read<Object>(
        _customerKey(key, customerId),
      );

      final decoded = raw is String ? jsonDecode(raw) : raw;

      return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCustomerState(
    String key,
    Map<String, dynamic> value, {
    required int? customerId,
  }) =>
      _writeLocal(
        () => _box.write(
          _customerKey(key, customerId),
          jsonEncode(value),
        ),
      );

  Future<void> deleteCustomerState(
    int customerId,
  ) async {
    for (final key in [
      StorageKeys.customerCart,
      StorageKeys.customerLocation,
      StorageKeys.customerAiChat,
    ]) {
      await _writeLocal(
        () => _box.remove(
          _customerKey(key, customerId),
        ),
      );
    }
  }

  /// Cache I/O must not interrupt cart actions
  /// or successful authentication.
  Future<void> _writeLocal(
    Future<void> Function() write,
  ) async {
    try {
      await write();
    } catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'Amar local customer storage',
          context: ErrorDescription(
            'saving local customer state',
          ),
        ),
      );
    }
  }

  int? get configVersion => _box.read<int>(StorageKeys.configVersion);

  Map<String, dynamic>? get cachedConfig {
    final raw = _box.read<String>(
      StorageKeys.configCache,
    );

    if (raw == null) return null;

    return Map<String, dynamic>.from(
      jsonDecode(raw) as Map,
    );
  }

  Future<void> saveConfig(
    int version,
    Map<String, dynamic> json,
  ) async {
    await _box.write(
      StorageKeys.configVersion,
      version,
    );

    await _box.write(
      StorageKeys.configCache,
      jsonEncode(json),
    );
  }
}
