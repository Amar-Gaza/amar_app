import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/shared/device_location_service.dart';
import '../storage/app_preferences.dart';

class LocaleController extends GetxController {
  LocaleController(this._prefs, this._location);

  final AppPreferences _prefs;
  final DeviceLocationService _location;
  late final Rx<Locale> locale = Locale(_prefs.locale).obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(_location.setLanguage(locale.value.languageCode));
  }

  Future<void> change(String languageCode) async {
    await _prefs.setLocale(languageCode);
    locale.value = Locale(languageCode);
    unawaited(Get.updateLocale(locale.value));
    await _location.setLanguage(languageCode);
  }
}
