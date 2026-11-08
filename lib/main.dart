import 'package:flutter/material.dart';

import 'app/amar_app.dart';
import 'controllers/shared/push_controller.dart';
import 'core/storage/app_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushController.bootstrap();
  final prefs = await AppPreferences.init();
  runApp(AmarApp(prefs: prefs));
}
