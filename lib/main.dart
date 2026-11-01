import 'package:flutter/material.dart';

import 'app/amar_app.dart';
import 'core/storage/app_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await AppPreferences.init();
  runApp(AmarApp(prefs: prefs));
}
