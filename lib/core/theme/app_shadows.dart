import 'package:flutter/material.dart';

import 'app_color_extension.dart';

/// Brand-tinted elevation used by buttons and cards.
abstract final class AppShadows {
  static const double _buttonAlpha = 0.25;
  static const double _cardAlpha = 0.07;
  static const double _heroAlpha = 0.27;
  static const double _focusAlpha = 0.12;
  static const double _selectedAlpha = 0.13;
  static const double _focusSpread = 4;

  static List<BoxShadow> button(AppColorExtension colors) => [
        BoxShadow(
          color: colors.brand.withValues(alpha: _buttonAlpha),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> card(AppColorExtension colors) => [
        BoxShadow(
          color: colors.brand.withValues(alpha: _cardAlpha),
          blurRadius: 22,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> hero(AppColorExtension colors) => [
        BoxShadow(
          color: colors.brand.withValues(alpha: _heroAlpha),
          blurRadius: 26,
          offset: const Offset(0, 12),
        ),
      ];

  static List<BoxShadow> selected(AppColorExtension colors) => [
        BoxShadow(
          color: colors.brand.withValues(alpha: _selectedAlpha),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ];

  static List<BoxShadow> focus(AppColorExtension colors) => [
        BoxShadow(
          color: colors.brandBright.withValues(alpha: _focusAlpha),
          spreadRadius: _focusSpread,
        ),
      ];
}
