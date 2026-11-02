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
    required this.brandBright,
    required this.brandDeep,
    required this.amber,
    required this.onAmber,
    required this.disabled,
    required this.promoStart,
    required this.promoEnd,
    required this.onPromo,
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

  /// Lighter end of the brand gradient, focus rings and links.
  final Color brandBright;

  /// Darker start of the hero gradient (splash, order and profile cards).
  final Color brandDeep;

  /// Attention dot, current progress step and the cart badge.
  final Color amber;
  final Color onAmber;

  /// Background of disabled primary buttons.
  final Color disabled;

  /// Promo banner gradient and its content color.
  final Color promoStart;
  final Color promoEnd;
  final Color onPromo;

  LinearGradient get brandGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [brand, brandBright],
      );

  LinearGradient get heroGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [brandDeep, brandBright],
      );

  LinearGradient get promoGradient => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [promoStart, promoEnd],
      );

  static const AppColorExtension light = AppColorExtension(
    brand: Color(0xFF14624A),
    onBrand: Color(0xFFFFFFFF),
    brandSoft: Color(0xFFE3EDEA),
    ink: Color(0xFF13281F),
    onInk: Color(0xFFFFFFFF),
    accent: Color(0xFFCDEBDC),
    surfaceSoft: Color(0xFFF1F6F4),
    success: Color(0xFF1F7A55),
    successSoft: Color(0xFFE3F3E8),
    warning: Color(0xFF9A6200),
    warningSoft: Color(0xFFFFF3D9),
    danger: Color(0xFFC0392B),
    dangerSoft: Color(0xFFFDECEB),
    info: Color(0xFF2F5BD1),
    infoSoft: Color(0xFFE0EBFF),
    highlightSoft: Color(0xFFFDE4EF),
    border: Color(0xFFDDE7E2),
    skeleton: Color(0xFFE3EDEA),
    mutedText: Color(0xFF667A70),
    subtleText: Color(0xFF8AA196),
    brandBright: Color(0xFF1F8A66),
    brandDeep: Color(0xFF0F5240),
    amber: Color(0xFFF2A93B),
    onAmber: Color(0xFF4A2F00),
    disabled: Color(0xFFC9D6D0),
    promoStart: Color(0xFFFBE7C0),
    promoEnd: Color(0xFFF7D089),
    onPromo: Color(0xFF5B3B05),
  );

  static const AppColorExtension dark = AppColorExtension(
    brand: Color(0xFF3DB58F),
    onBrand: Color(0xFF0E1F1D),
    brandSoft: Color(0xFF17392E),
    ink: Color(0xFFE6F2EF),
    onInk: Color(0xFF0E1F1D),
    accent: Color(0xFFCDEBDC),
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
    brandBright: Color(0xFF4CC28F),
    brandDeep: Color(0xFF14624A),
    amber: Color(0xFFF2A93B),
    onAmber: Color(0xFF4A2F00),
    disabled: Color(0xFF2F4640),
    promoStart: Color(0xFF3A2C14),
    promoEnd: Color(0xFF4A3818),
    onPromo: Color(0xFFFBE7C0),
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
    Color? brandBright,
    Color? brandDeep,
    Color? amber,
    Color? onAmber,
    Color? disabled,
    Color? promoStart,
    Color? promoEnd,
    Color? onPromo,
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
        brandBright: brandBright ?? this.brandBright,
        brandDeep: brandDeep ?? this.brandDeep,
        amber: amber ?? this.amber,
        onAmber: onAmber ?? this.onAmber,
        disabled: disabled ?? this.disabled,
        promoStart: promoStart ?? this.promoStart,
        promoEnd: promoEnd ?? this.promoEnd,
        onPromo: onPromo ?? this.onPromo,
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
      brandBright: mix(brandBright, other.brandBright),
      brandDeep: mix(brandDeep, other.brandDeep),
      amber: mix(amber, other.amber),
      onAmber: mix(onAmber, other.onAmber),
      disabled: mix(disabled, other.disabled),
      promoStart: mix(promoStart, other.promoStart),
      promoEnd: mix(promoEnd, other.promoEnd),
      onPromo: mix(onPromo, other.onPromo),
    );
  }
}
