import 'dart:convert';

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

  int? get configVersion => _box.read<int>(StorageKeys.configVersion);

  Map<String, dynamic>? get cachedConfig {
    final raw = _box.read<String>(StorageKeys.configCache);
    if (raw == null) return null;
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  Future<void> saveConfig(int version, Map<String, dynamic> json) async {
    await _box.write(StorageKeys.configVersion, version);
    await _box.write(StorageKeys.configCache, jsonEncode(json));
  }
}
