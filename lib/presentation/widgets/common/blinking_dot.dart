import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_sizes.dart';

/// Small round dot that fades in and out: live states (online, in progress).
class BlinkingDot extends StatefulWidget {
  const BlinkingDot({
    super.key,
    required this.color,
    this.size = AppSizes.offlineDot,
    this.animate = true,
    this.shape = BoxShape.circle,
  });

  static const double _minOpacity = 0.3;

  final Color color;
  final double size;
  final bool animate;
  final BoxShape shape;

  @override
  State<BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<BlinkingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.blink,
    lowerBound: BlinkingDot._minOpacity,
  );

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(BlinkingDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animate != widget.animate) _sync();
  }

  void _sync() {
    if (widget.animate) {
      _controller.repeat(reverse: true);
    } else {
      _controller
        ..stop()
        ..value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _controller,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color,
            shape: widget.shape,
          ),
        ),
      );
}
