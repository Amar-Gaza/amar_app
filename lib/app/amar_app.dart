
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/localization/locale_controller.dart';
import '../core/storage/app_preferences.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../presentation/widgets/ai/ai_task_overlay.dart';
import 'bindings/initial_binding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class AmarApp extends StatelessWidget {
  const AmarApp({super.key, required this.prefs});

  final AppPreferences prefs;

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    initialBinding: InitialBinding(prefs),
    initialRoute: AppRoutes.splash,
    getPages: AppPages.pages,
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: AppTheme.mode,
    locale: Locale(prefs.locale),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    onInit: () => Get.find<LocaleController>(),
    // The progress strip survives route transitions and shows real screens.
    builder: (context, child) => Stack(
      children: [
        if (child != null) child,
        const AiTaskOverlay(),
      ],
    ),
  );
}
