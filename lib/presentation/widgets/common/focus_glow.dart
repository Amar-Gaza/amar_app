import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/theme_context.dart';

/// Soft ring around a field while a descendant has focus.
class FocusGlow extends StatefulWidget {
  const FocusGlow({super.key, required this.child, required this.borderRadius});

  final Widget child;
  final BorderRadius borderRadius;

  @override
  State<FocusGlow> createState() => _FocusGlowState();
}

class _FocusGlowState extends State<FocusGlow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) => Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onFocusChange: (value) => setState(() => _focused = value),
        child: AnimatedContainer(
          duration: AppDurations.fast,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            boxShadow: _focused ? AppShadows.focus(context.appColors) : null,
          ),
          child: widget.child,
        ),
      );
}
