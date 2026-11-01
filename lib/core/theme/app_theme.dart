import 'package:flutter/material.dart';

import 'app_color_extension.dart';
import 'app_radius.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  /// Single switch for the active theme. Dark is prepared but disabled.
  static const ThemeMode mode = ThemeMode.light;

  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _darkSurface = Color(0xFF0E1F1D);

  static ThemeData light() =>
      _build(Brightness.light, AppColorExtension.light, _lightSurface);

  static ThemeData dark() =>
      _build(Brightness.dark, AppColorExtension.dark, _darkSurface);

  static ThemeData _build(
    Brightness brightness,
    AppColorExtension colors,
    Color surface,
  ) {
    final scheme = ColorScheme.fromSeed(
      seedColor: colors.brand,
      brightness: brightness,
    ).copyWith(
      primary: colors.brand,
      onPrimary: colors.onBrand,
      surface: surface,
      onSurface: colors.ink,
      error: colors.danger,
      outline: colors.border,
      outlineVariant: colors.border,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppTypography.fontFamily,
    );
    const buttonShape = RoundedRectangleBorder(borderRadius: AppRadius.mdAll);
    const buttonSize = Size.fromHeight(AppSizes.buttonHeight);
    final buttonText = base.textTheme.labelLarge?.copyWith(
      fontFamily: AppTypography.fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: AppTypography.body,
    );
    OutlineInputBorder border(Color color, [double? width]) =>
        OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(
            color: color,
            width: width ?? AppSizes.borderWidth,
          ),
        );
    return base.copyWith(
      scaffoldBackgroundColor: surface,
      textTheme:
          AppTypography.apply(base.textTheme, colors.ink, colors.mutedText),
      extensions: [colors],
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: AppSizes.borderWidth,
        space: AppSizes.borderWidth,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: colors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.brand,
          foregroundColor: colors.onBrand,
          disabledBackgroundColor: colors.brand.withValues(alpha: 0.45),
          disabledForegroundColor: colors.onBrand,
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.brand,
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: buttonText,
          side: BorderSide(color: colors.border, width: AppSizes.borderWidth),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.brand,
          textStyle: buttonText?.copyWith(fontSize: AppTypography.caption),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.brand,
        linearTrackColor: colors.skeleton,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: colors.subtleText),
        prefixIconColor: colors.mutedText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: border(colors.border),
        enabledBorder: border(colors.border),
        focusedBorder: border(colors.brand, AppSizes.borderWidthActive),
        errorBorder: border(colors.danger),
        focusedErrorBorder: border(colors.danger, AppSizes.borderWidthActive),
      ),
    );
  }
}
