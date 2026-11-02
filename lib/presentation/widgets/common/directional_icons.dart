import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Arrows that follow the reading direction (RTL points the other way).
abstract final class DirectionalIcons {
  static bool _rtl(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl;

  static IconData back(BuildContext context) =>
      _rtl(context) ? LucideIcons.chevronRight : LucideIcons.chevronLeft;

  static IconData forward(BuildContext context) =>
      _rtl(context) ? LucideIcons.chevronLeft : LucideIcons.chevronRight;
}
