import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';

/// White bar with a smooth notch under the active tab's bubble.
class NavBarPainter extends CustomPainter {
  const NavBarPainter({
    required this.center,
    required this.color,
    required this.shadow,
  });

  static const double _notchHalf = 44;
  static const double _curve = 22;
  static const double _bottomControl = 30;
  static const double _corner = 16;
  static const double _elevation = 8;

  final double center;
  final Color color;
  final Color shadow;

  Path _bar(Size size) {
    const top = AppSizes.navBarTop;
    const depth = AppSizes.navNotchDepth;
    final left = center - _notchHalf;
    final right = center + _notchHalf;
    return Path()
      ..moveTo(0, top + _corner)
      ..quadraticBezierTo(0, top, _corner, top)
      ..lineTo(left, top)
      ..cubicTo(
        left + _curve,
        top,
        center - _bottomControl,
        depth,
        center,
        depth,
      )
      ..cubicTo(
        center + _bottomControl,
        depth,
        right - _curve,
        top,
        right,
        top,
      )
      ..lineTo(size.width - _corner, top)
      ..quadraticBezierTo(size.width, top, size.width, top + _corner)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _bar(size);
    canvas
      ..drawShadow(path, shadow, _elevation, false)
      ..drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(NavBarPainter oldDelegate) =>
      center != oldDelegate.center ||
      color != oldDelegate.color ||
      shadow != oldDelegate.shadow;
}
