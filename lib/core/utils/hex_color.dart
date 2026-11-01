import 'package:flutter/painting.dart';

/// Parses server colors such as `#F59E0B` (statuses, project colors).
abstract final class HexColor {
  static const int _opaque = 0xFF000000;
  static const int _rgbLength = 6;
  static const int _radix = 16;

  static Color? tryParse(String? value) {
    final hex = value?.replaceFirst('#', '') ?? '';
    if (hex.length != _rgbLength) return null;
    final rgb = int.tryParse(hex, radix: _radix);
    return rgb == null ? null : Color(_opaque | rgb);
  }
}
