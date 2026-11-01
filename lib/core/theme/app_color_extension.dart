import 'package:flutter/material.dart';

@immutable
class AppColorExtension extends ThemeExtension<AppColorExtension> {
  const AppColorExtension({
    required this.brand,
    required this.onBrand,
    required this.brandSoft,
    required this.ink,
    required this.onInk,
    required this.accent,
    required this.surfaceSoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.info,
    required this.infoSoft,
    required this.highlightSoft,
    required this.border,
    required this.skeleton,
    required this.mutedText,
    required this.subtleText,
  });

  /// Primary action color (buttons, links, active states).
  final Color brand;
  final Color onBrand;

  /// Tinted background behind brand icons.
  final Color brandSoft;

  /// Main text color and dark surfaces (splash, highlighted cards).
  final Color ink;
  final Color onInk;

  /// Mint accent used by the brand mark and on dark surfaces.
  final Color accent;

  /// Very light tinted surface for notes and grouped content.
  final Color surfaceSoft;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color info;
  final Color infoSoft;
  final Color highlightSoft;
  final Color border;
  final Color skeleton;
  final Color mutedText;
  final Color subtleText;

  static const AppColorExtension light = AppColorExtension(
    brand: Color(0xFF238778),
    onBrand: Color(0xFFFFFFFF),
    brandSoft: Color(0xFFE6F5F1),
    ink: Color(0xFF243B3A),
    onInk: Color(0xFFFFFFFF),
    accent: Color(0xFFB7FBED),
    surfaceSoft: Color(0xFFF0F8F6),
    success: Color(0xFF167A55),
    successSoft: Color(0xFFE5F6ED),
    warning: Color(0xFFB46A09),
    warningSoft: Color(0xFFFFF2DD),
    danger: Color(0xFFC33D4E),
    dangerSoft: Color(0xFFFDECEF),
    info: Color(0xFF2672A8),
    infoSoft: Color(0xFFE8F1FA),
    highlightSoft: Color(0xFFFCEAF6),
    border: Color(0xFFDCEFEA),
    skeleton: Color(0xFFE8EFED),
    mutedText: Color(0xFF667C78),
    subtleText: Color(0xFFA7B8B4),
  );

  static const AppColorExtension dark = AppColorExtension(
    brand: Color(0xFF3DB5A2),
    onBrand: Color(0xFF0E1F1D),
    brandSoft: Color(0xFF173A36),
    ink: Color(0xFFE6F2EF),
    onInk: Color(0xFF0E1F1D),
    accent: Color(0xFFB7FBED),
    surfaceSoft: Color(0xFF15292A),
    success: Color(0xFF4CC28F),
    successSoft: Color(0xFF15302A),
    warning: Color(0xFFE9A645),
    warningSoft: Color(0xFF3A2C14),
    danger: Color(0xFFE77786),
    dangerSoft: Color(0xFF3A1D23),
    info: Color(0xFF6BAEDD),
    infoSoft: Color(0xFF16283A),
    highlightSoft: Color(0xFF35202F),
    border: Color(0xFF2A4542),
    skeleton: Color(0xFF223634),
    mutedText: Color(0xFF9DB2AE),
    subtleText: Color(0xFF6E8581),
  );

  @override
  AppColorExtension copyWith({
    Color? brand,
    Color? onBrand,
    Color? brandSoft,
    Color? ink,
    Color? onInk,
    Color? accent,
    Color? surfaceSoft,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? danger,
    Color? dangerSoft,
    Color? info,
    Color? infoSoft,
    Color? highlightSoft,
    Color? border,
    Color? skeleton,
    Color? mutedText,
    Color? subtleText,
  }) =>
      AppColorExtension(
        brand: brand ?? this.brand,
        onBrand: onBrand ?? this.onBrand,
        brandSoft: brandSoft ?? this.brandSoft,
        ink: ink ?? this.ink,
        onInk: onInk ?? this.onInk,
        accent: accent ?? this.accent,
        surfaceSoft: surfaceSoft ?? this.surfaceSoft,
        success: success ?? this.success,
        successSoft: successSoft ?? this.successSoft,
        warning: warning ?? this.warning,
        warningSoft: warningSoft ?? this.warningSoft,
        danger: danger ?? this.danger,
        dangerSoft: dangerSoft ?? this.dangerSoft,
        info: info ?? this.info,
        infoSoft: infoSoft ?? this.infoSoft,
        highlightSoft: highlightSoft ?? this.highlightSoft,
        border: border ?? this.border,
        skeleton: skeleton ?? this.skeleton,
        mutedText: mutedText ?? this.mutedText,
        subtleText: subtleText ?? this.subtleText,
      );

  @override
  AppColorExtension lerp(ThemeExtension<AppColorExtension>? other, double t) {
    if (other is! AppColorExtension) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColorExtension(
      brand: mix(brand, other.brand),
      onBrand: mix(onBrand, other.onBrand),
      brandSoft: mix(brandSoft, other.brandSoft),
      ink: mix(ink, other.ink),
      onInk: mix(onInk, other.onInk),
      accent: mix(accent, other.accent),
      surfaceSoft: mix(surfaceSoft, other.surfaceSoft),
      success: mix(success, other.success),
      successSoft: mix(successSoft, other.successSoft),
      warning: mix(warning, other.warning),
      warningSoft: mix(warningSoft, other.warningSoft),
      danger: mix(danger, other.danger),
      dangerSoft: mix(dangerSoft, other.dangerSoft),
      info: mix(info, other.info),
      infoSoft: mix(infoSoft, other.infoSoft),
      highlightSoft: mix(highlightSoft, other.highlightSoft),
      border: mix(border, other.border),
      skeleton: mix(skeleton, other.skeleton),
      mutedText: mix(mutedText, other.mutedText),
      subtleText: mix(subtleText, other.subtleText),
    );
  }
}
