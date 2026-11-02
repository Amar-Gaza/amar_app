import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Diagonal road-like lines behind the decorative location map.
class MapStripesPainter extends CustomPainter {
  const MapStripesPainter({required this.road, required this.street});

  static const double _roadGap = 31;
  static const double _roadWidth = 3;
  static const double _streetGap = 43;
  static const double _streetAngle = math.pi / 3;

  final Color road;
  final Color street;

  @override
  void paint(Canvas canvas, Size size) {
    _lines(canvas, size, road, _roadGap, math.pi / 4);
    _lines(canvas, size, street, _streetGap, _streetAngle);
  }

  void _lines(Canvas canvas, Size size, Color color, double gap, double angle) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = _roadWidth;
    final reach = size.longestSide * 2;
    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2)
      ..rotate(angle);
    for (var offset = -reach; offset <= reach; offset += gap) {
      canvas.drawLine(Offset(offset, -reach), Offset(offset, reach), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(MapStripesPainter oldDelegate) =>
      road != oldDelegate.road || street != oldDelegate.street;
}
