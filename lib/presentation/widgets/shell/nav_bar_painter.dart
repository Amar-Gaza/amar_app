import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Floating pill whose top edge dips into a rounded notch under the
/// bubble, joined to the bar by smooth curves. The notch follows the
/// bubble sideways and fills in while it is in the air.
class NavBarPainter extends CustomPainter {
  const NavBarPainter({
    required this.center,
    required this.bubbleCenterY,
    required this.bubbleRadius,
    required this.raise,
    required this.color,
    required this.shadow,
  });

  static const double corner = 26;

  /// Gap between the bubble and the notch edge.
  static const double _ring = 6;

  /// How soft the join between the bar and the notch is.
  static const double _blend = 14;
  static const int _samples = 120;

  /// Bubble centre on x, in the pill's coordinates.
  final double center;

  /// Bubble centre on y at rest, relative to the pill's top edge.
  final double bubbleCenterY;
  final double bubbleRadius;

  /// 1 while the bubble rests in the notch, towards 0 while it jumps.
  final double raise;
  final Color color;
  final Color shadow;

  /// Polynomial smooth maximum: the larger of [a] and [b] with a rounded
  /// fillet where they meet.
  static double _smoothMax(double a, double b, double k) {
    final h = (0.5 + 0.5 * (a - b) / k).clamp(0.0, 1.0);
    return b + (a - b) * h + k * h * (1 - h);
  }

  double _topAt(double x, double width) {
    // Rounded pill corners.
    var edge = 0.0;
    if (x < corner) {
      final d = corner - x;
      edge = corner - math.sqrt(corner * corner - d * d);
    } else if (x > width - corner) {
      final d = x - (width - corner);
      edge = corner - math.sqrt(corner * corner - d * d);
    }

    // Lower half of the notch circle under the bubble.
    final r = bubbleRadius + _ring;
    final dx = (x - center).abs();
    final notch = dx < r
        ? bubbleCenterY + math.sqrt(r * r - dx * dx)
        : bubbleCenterY - (dx - r);

    final joined = _smoothMax(edge, notch, _blend);
    // Only the part cut below the bar's edge fills in while the bubble jumps.
    return joined > edge ? edge + (joined - edge) * raise : joined;
  }

  Path _path(Size size) {
    final w = size.width;
    final path = Path()..moveTo(0, _topAt(0, w));
    for (var i = 1; i <= _samples; i++) {
      final x = w * i / _samples;
      path.lineTo(x, _topAt(x, w));
    }
    return path
      ..lineTo(w, size.height - corner)
      ..arcToPoint(
        Offset(w - corner, size.height),
        radius: const Radius.circular(corner),
      )
      ..lineTo(corner, size.height)
      ..arcToPoint(
        Offset(0, size.height - corner),
        radius: const Radius.circular(corner),
      )
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= corner * 2) return;
    final path = _path(size);
    canvas
      ..drawPath(
        path.shift(const Offset(0, 6)),
        Paint()
          ..color = shadow
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      )
      ..drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(NavBarPainter oldDelegate) =>
      center != oldDelegate.center ||
      bubbleCenterY != oldDelegate.bubbleCenterY ||
      bubbleRadius != oldDelegate.bubbleRadius ||
      raise != oldDelegate.raise ||
      color != oldDelegate.color ||
      shadow != oldDelegate.shadow;
}
