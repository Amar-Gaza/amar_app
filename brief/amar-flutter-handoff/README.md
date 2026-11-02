# Amar · Flutter handoff pack

- `lib/l10n/app_ar.arb`, `lib/l10n/app_en.arb` + `l10n.yaml`: every status, field, option, button,
  cancel reason and error message of this project. Add `flutter_localizations` and `generate: true`
  to pubspec.yaml, then run `flutter gen-l10n`.
- `lib/theme/masar_theme.dart`: `MasarTheme.light()` / `MasarTheme.dark()` from the brand color.
- `lib/theme/masar_icons.dart`: status icon names → Lucide icons (package `lucide_icons_flutter`).

Never write status or error texts in code: use the ARB files, and download the pack again after every publish.

لا تكتب نصوص الحالات أو الأخطاء داخل الكود: استخدم ملفات ARB، وأعد تنزيل الحزمة بعد كل نشر.