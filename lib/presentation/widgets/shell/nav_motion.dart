import 'dart:math' as math;

import '../../../core/theme/app_sizes.dart';

/// Shared motion settings for the nav bubble: a single clean hop
/// from tab to tab, with no landing bounce.
abstract final class NavMotion {
  static const Duration duration = Duration(milliseconds: 520);

  static const double iconSwitchAt = 0.5;

  static const double jumpHeight = AppSizes.navBubble * 0.6;

  static const double airStretchX = 0.06;
  static const double airStretchY = 0.08;

  /// Resting top of the bubble relative to the pill's top edge: its centre
  /// sits on the edge, half of it inside the notch above the label.
  static const double restTop = -AppSizes.navBubble / 2;

  static NavMotionFrame sample({
    required NavMotionFrame start,
    required double target,
    required double progress,
  }) {
    final t = progress.clamp(0.0, 1.0).toDouble();

    if (t == 0) return start;
    if (t == 1) return NavMotionFrame.rest(target);

    final u = _easeInOut(t);
    final arc = math.sin(math.pi * t);

    return NavMotionFrame(
      index: start.index + (target - start.index) * u,
      // Continue smoothly from the current height when tapped mid-air.
      lift: start.lift * (1 - t) + arc * jumpHeight,
      scaleX: 1 - arc * airStretchX,
      scaleY: 1 + arc * airStretchY,
    );
  }

  static double _easeInOut(double t) =>
      t < 0.5 ? 4 * t * t * t : 1 - math.pow(-2 * t + 2, 3).toDouble() / 2;
}

class NavMotionFrame {
  const NavMotionFrame({
    required this.index,
    this.lift = 0,
    this.scaleX = 1,
    this.scaleY = 1,
  });

  const NavMotionFrame.rest(this.index)
      : lift = 0,
        scaleX = 1,
        scaleY = 1;

  final double index;
  final double lift;
  final double scaleX;
  final double scaleY;
}
