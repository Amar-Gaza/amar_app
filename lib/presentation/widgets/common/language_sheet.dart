import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_defaults.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';

/// Bottom sheet listing the supported app languages.
class LanguageSheet extends StatelessWidget {
  const LanguageSheet({super.key, required this.current});

  final String current;

  static Future<String?> show(BuildContext context, String current) =>
      showModalBottomSheet<String>(
        context: context,
        builder: (_) => LanguageSheet(current: current),
      );

  static String label(AppLocalizations l10n, String code) =>
      code == AppDefaults.languageEnglish
          ? l10n.languageEnglish
          : l10n.languageArabic;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.profileLanguageLabel, style: context.text.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            for (final code in [
              AppDefaults.languageArabic,
              AppDefaults.languageEnglish,
            ])
              ListTile(
                title: Text(label(l10n, code)),
                trailing: code == current
                    ? Icon(LucideIcons.check, color: context.appColors.brand)
                    : null,
                onTap: () => Navigator.of(context).pop(code),
              ),
          ],
        ),
      ),
    );
  }
}
