import 'dart:math' as math;

import '../../../core/theme/app_sizes.dart';

/// Shared motion settings for the bubble and the water surface.
abstract final class NavMotion {
  static const Duration duration = Duration(milliseconds: 820);

  static const double takeoffEnd = 0.12;
  static const double landingAt = 0.72;
  static const double iconSwitchAt = 0.42;

  static const double jumpHeight = AppSizes.navBubble * 0.85;
  static const double maxLift = AppSizes.navBubble * 1.5;
  static const double launchDip = AppSizes.navBubble * 0.055;
  static const double impactDepth = AppSizes.navBubble * 0.085;

  static const double launchScaleX = 1.16;
  static const double launchScaleY = 0.84;

  static const double airStretchX = 0.08;
  static const double airStretchY = 0.14;

  static const double impactScaleX = 0.18;
  static const double impactScaleY = 0.14;
  static const double impactCycles = 3;
  static const double impactDamping = 5;

  static NavMotionFrame sample({
    required NavMotionFrame start,
    required double target,
    required double progress,
  }) {
    final t = progress.clamp(0.0, 1.0).toDouble();

    if (t == 0) return start;
    if (t == 1) return NavMotionFrame.rest(target);

    final airborne = start.lift > 0;
    final launchLift = airborne ? start.lift : -launchDip;
    final launchX = airborne ? 1.0 : launchScaleX;
    final launchY = airborne ? 1.0 : launchScaleY;

    if (t < takeoffEnd) {
      final u = _easeOut(t / takeoffEnd);

      return NavMotionFrame(
        index: start.index,
        lift: _lerp(start.lift, launchLift, u),
        scaleX: _lerp(start.scaleX, launchX, u),
        scaleY: _lerp(start.scaleY, launchY, u),
      );
    }

    if (t < landingAt) {
      final u = (t - takeoffEnd) / (landingAt - takeoffEnd);
      final arc = math.sin(math.pi * u);

      return NavMotionFrame(
        index: _lerp(start.index, target, _easeInOut(u)),
        lift: math.min(
          maxLift,
          launchLift * (1 - u) + arc * jumpHeight,
        ),
        scaleX: _lerp(launchX, 1, u) - arc * airStretchX,
        scaleY: _lerp(launchY, 1, u) + arc * airStretchY,
      );
    }

    final u = (t - landingAt) / (1 - landingAt);

    final spring =
        math.sin(u * math.pi * impactCycles) *
            math.exp(-impactDamping * u) *
            (1 - u);

    return NavMotionFrame(
      index: target,
      lift: -spring * impactDepth,
      scaleX: 1 + spring * impactScaleX,
      scaleY: 1 - spring * impactScaleY,
      ripple: u,
    );
  }

  static double _lerp(double a, double b, double t) =>
      a + (b - a) * t;

  static double _easeOut(double t) =>
      1 - math.pow(1 - t, 3).toDouble();

  static double _easeInOut(double t) => t < 0.5
      ? 4 * t * t * t
      : 1 - math.pow(-2 * t + 2, 3).toDouble() / 2;
}

class NavMotionFrame {
  const NavMotionFrame({
    required this.index,
    this.lift = 0,
    this.scaleX = 1,
    this.scaleY = 1,
    this.ripple = 0,
  });

  const NavMotionFrame.rest(this.index)
      : lift = 0,
        scaleX = 1,
        scaleY = 1,
        ripple = 0;

  final double index;
  final double lift;
  final double scaleX;
  final double scaleY;
  final double ripple;
}