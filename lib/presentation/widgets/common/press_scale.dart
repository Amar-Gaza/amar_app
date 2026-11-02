import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';

/// Shrinks its child slightly while it is pressed.
class PressScale extends StatefulWidget {
  const PressScale({super.key, required this.child, this.onTap});

  static const double _pressedScale = 0.97;

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap != null) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _pressed ? PressScale._pressedScale : 1,
          duration: AppDurations.press,
          child: widget.child,
        ),
      );
}
