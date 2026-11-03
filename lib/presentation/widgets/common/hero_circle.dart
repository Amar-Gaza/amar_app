import 'package:flutter/material.dart';

import '../../../core/theme/theme_context.dart';

/// Faint decorative circle drawn behind gradient hero cards.
class HeroCircle extends StatelessWidget {
  const HeroCircle({super.key, required this.size, required this.alpha});

  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.appColors.onBrand.withValues(alpha: alpha),
          shape: BoxShape.circle,
        ),
      );
}
