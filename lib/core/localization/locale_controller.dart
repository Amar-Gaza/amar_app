import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../storage/app_preferences.dart';

class LocaleController extends GetxController {
  LocaleController(this._prefs);

  final AppPreferences _prefs;
  late final Rx<Locale> locale = Locale(_prefs.locale).obs;

  Future<void> change(String languageCode) async {
    await _prefs.setLocale(languageCode);
    locale.value = Locale(languageCode);
    Get.updateLocale(locale.value);
  }
}
