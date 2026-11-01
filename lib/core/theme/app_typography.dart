import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String fontFamily = 'Cairo';

  static const double display = 26;
  static const double title = 24;
  static const double headline = 20;
  static const double subtitle = 16;
  static const double body = 14;
  static const double caption = 12;
  static const double tiny = 11;
  static const double otp = 22;

  static TextTheme apply(TextTheme base, Color ink, Color muted) {
    final themed = base.apply(
      fontFamily: fontFamily,
      bodyColor: ink,
      displayColor: ink,
    );
    return themed.copyWith(
      headlineLarge: themed.headlineLarge
          ?.copyWith(fontSize: display, fontWeight: FontWeight.w800),
      headlineMedium: themed.headlineMedium
          ?.copyWith(fontSize: title, fontWeight: FontWeight.w500),
      headlineSmall: themed.headlineSmall
          ?.copyWith(fontSize: headline, fontWeight: FontWeight.w600),
      titleLarge: themed.titleLarge
          ?.copyWith(fontSize: subtitle, fontWeight: FontWeight.w700),
      titleMedium: themed.titleMedium
          ?.copyWith(fontSize: body, fontWeight: FontWeight.w700),
      titleSmall: themed.titleSmall
          ?.copyWith(fontSize: caption, fontWeight: FontWeight.w700),
      bodyLarge: themed.bodyLarge?.copyWith(fontSize: subtitle),
      bodyMedium: themed.bodyMedium?.copyWith(fontSize: body),
      bodySmall: themed.bodySmall?.copyWith(fontSize: caption, color: muted),
      labelLarge: themed.labelLarge
          ?.copyWith(fontSize: body, fontWeight: FontWeight.w700),
      labelMedium: themed.labelMedium
          ?.copyWith(fontSize: caption, fontWeight: FontWeight.w700),
      labelSmall: themed.labelSmall?.copyWith(
        fontSize: tiny,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
    );
  }
}
