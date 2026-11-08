import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';
import 'nav_motion.dart';

/// A soft notch that recovers during flight and ripples on landing.
class NavBarPainter extends CustomPainter {
  const NavBarPainter({
    required this.center,
    required this.color,
    required this.shadow,
    required this.waterColor,
    this.lift = 0,
    this.ripple = 0,
  });

  static const double _notchHalf = 44;
  static const double _corner = 16;
  static const double _elevation = 8;
  static const int _samples = 96;

  static const double _waveAmplitude = 5;
  static const double _waveReach = 90;
  static const double _waveSpread = 22;

  static const double _rippleStart = 18;
  static const double _rippleEnd = 72;
  static const double _rippleHeight = 0.22;
  static const double _ringStroke = 1.6;
  static const double _ringAlpha = 0.3;

  static const double _dropletRadius = 2.2;
  static const double _splashHeight = 24;
  static const double _shadowAlpha = 0.12;
  static const double _surfaceAlpha = 0.16;

  final double center;
  final Color color;
  final Color shadow;
  final Color waterColor;
  final double lift;
  final double ripple;

  double _surfaceY(double x, double width) {
    final safeCenter = center.clamp(_corner, width - _corner).toDouble();

    final half = math.min(
      _notchHalf,
      math.max(
        0.0,
        math.min(safeCenter, width - safeCenter) - _corner,
      ),
    );

    final distance = (x - safeCenter).abs();

    final immersion = 1 - (lift / NavMotion.jumpHeight).clamp(0.0, 1.0) * 0.85;

    final profile = half > 0 && distance < half
        ? (1 + math.cos(math.pi * distance / half)) / 2
        : 0.0;

    final depth = (AppSizes.navNotchDepth - AppSizes.navBarTop) * immersion;

    var wave = 0.0;

    if (ripple > 0 && ripple < 1) {
      final radius = _waveReach * ripple;

      final envelope = math.exp(
        -math.pow((distance - radius) / _waveSpread, 2),
      );

      final fade = math.sin(math.pi * ripple) * (1 - ripple);

      final edge = (math.min(x - _corner, width - _corner - x) / _corner)
          .clamp(0.0, 1.0)
          .toDouble();

      wave = math.sin(
            (distance - radius) / _waveSpread * math.pi,
          ) *
          envelope *
          fade *
          _waveAmplitude *
          edge;
    }

    return AppSizes.navBarTop + depth * profile + wave;
  }

  Path _surface(Size size) {
    final path = Path()..moveTo(_corner, AppSizes.navBarTop);

    for (var i = 1; i <= _samples; i++) {
      final x = _corner + (size.width - _corner * 2) * i / _samples;

      path.lineTo(x, _surfaceY(x, size.width));
    }

    return path;
  }

  Path _bar(Size size) {
    final path = Path()
      ..moveTo(0, AppSizes.navBarTop + _corner)
      ..quadraticBezierTo(
        0,
        AppSizes.navBarTop,
        _corner,
        AppSizes.navBarTop,
      );

    for (var i = 1; i <= _samples; i++) {
      final x = _corner + (size.width - _corner * 2) * i / _samples;

      path.lineTo(x, _surfaceY(x, size.width));
    }

    return path
      ..quadraticBezierTo(
        size.width,
        AppSizes.navBarTop,
        size.width,
        AppSizes.navBarTop + _corner,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  void _paintLanding(Canvas canvas) {
    if (ripple <= 0 || ripple >= 1) return;

    final fade = math.sin(math.pi * ripple) * (1 - ripple);

    final radius = _rippleStart + (_rippleEnd - _rippleStart) * ripple;

    final origin = Offset(
      center,
      AppSizes.navBubble * 0.8,
    );

    final ring = Paint()
      ..color = waterColor.withValues(
        alpha: fade * _ringAlpha,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = _ringStroke * (1 - ripple);

    canvas.drawOval(
      Rect.fromCenter(
        center: origin,
        width: radius * 2,
        height: radius * _rippleHeight,
      ),
      ring,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: origin,
        width: radius * 1.4,
        height: radius * _rippleHeight * 0.65,
      ),
      ring,
    );

    final splash = math.sin(
      math.pi * math.min(1.0, ripple * 2),
    );

    if (splash <= 0) return;

    final droplet = Paint()
      ..color = waterColor.withValues(
        alpha: fade * 0.6,
      );

    for (final side in [-1.0, 1.0]) {
      for (var i = 0; i < 2; i++) {
        final distance = (AppSizes.navBubble / 2 + ripple * _waveReach / 2) *
            (i == 0 ? 1.0 : 0.7);

        final y =
            AppSizes.navBarTop - splash * _splashHeight * (i == 0 ? 1.0 : 0.6);

        canvas.drawCircle(
          Offset(center + side * distance, y),
          _dropletRadius * (1 - ripple),
          droplet,
        );
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= _corner * 2) return;

    final path = _bar(size);

    canvas
      ..drawShadow(path, shadow, _elevation, false)
      ..drawPath(
        path,
        Paint()..color = color,
      );

    final air = (lift / NavMotion.jumpHeight).clamp(0.0, 1.0).toDouble();

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          center,
          AppSizes.navBubble * 0.82,
        ),
        width: AppSizes.navBubble * (0.65 - air * 0.25),
        height: AppSizes.navBubble * 0.12,
      ),
      Paint()
        ..color = waterColor.withValues(
          alpha: _shadowAlpha * (1 - air * 0.6),
        )
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          4,
        ),
    );

    if (ripple > 0) {
      canvas.drawPath(
        _surface(size),
        Paint()
          ..color = waterColor.withValues(
            alpha: _surfaceAlpha * (1 - ripple),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = _ringStroke,
      );
    }

    _paintLanding(canvas);
  }

  @override
  bool shouldRepaint(NavBarPainter oldDelegate) =>
      center != oldDelegate.center ||
      color != oldDelegate.color ||
      shadow != oldDelegate.shadow ||
      waterColor != oldDelegate.waterColor ||
      lift != oldDelegate.lift ||
      ripple != oldDelegate.ripple;
}
