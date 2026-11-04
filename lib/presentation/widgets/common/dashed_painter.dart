import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';

/// Dashed outline of a rounded rectangle, or a single top line when
/// [radius] is null.
class DashedPainter extends CustomPainter {
  const DashedPainter({
    required this.color,
    this.radius,
    this.strokeWidth = AppSizes.borderWidth,
  });

  final Color color;
  final double? radius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final inset = strokeWidth / 2;
    final path = radius == null
        ? (Path()
          ..moveTo(0, inset)
          ..lineTo(size.width, inset))
        : (Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(
                inset,
                inset,
                size.width - strokeWidth,
                size.height - strokeWidth,
              ),
              Radius.circular(radius!),
            ),
          ));
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + AppSizes.dashLength),
          paint,
        );
        distance += AppSizes.dashLength + AppSizes.dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(DashedPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeWidth != strokeWidth;
}
