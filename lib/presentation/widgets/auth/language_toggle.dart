import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_defaults.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';

/// Switches between Arabic and English from the auth top bar.
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocaleController>();
    final isArabic =
        locale.locale.value.languageCode == AppDefaults.languageArabic;
    return TextButton(
      onPressed: () => locale.change(
        isArabic ? AppDefaults.languageEnglish : AppDefaults.languageArabic,
      ),
      child: Text(
        AppLocalizations.of(context).languageToggle,
        style:
            context.text.labelMedium?.copyWith(color: context.appColors.brand),
      ),
    );
  }
}
