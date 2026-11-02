import 'package:flutter/painting.dart';

/// Background and icon color pairs cycled over the home categories.
abstract final class AppCategoryTints {
  static const List<(Color, Color)> values = [
    (Color(0xFFFFF3D6), Color(0xFFB7791F)),
    (Color(0xFFDFF2FB), Color(0xFF0E7490)),
    (Color(0xFFE0EBFF), Color(0xFF2F5BD1)),
    (Color(0xFFFDE6DC), Color(0xFFC2542D)),
    (Color(0xFFECE6FB), Color(0xFF6B46C1)),
    (Color(0xFFFDE4EF), Color(0xFFBE3A73)),
    (Color(0xFFFFF0CF), Color(0xFFC27C0E)),
    (Color(0xFFE3F3E8), Color(0xFF1F8A66)),
  ];

  static (Color, Color) at(int index) => values[index % values.length];
}
