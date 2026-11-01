import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/masar_icons.dart';

/// Lucide names used by category icons on the server.
const Map<String, IconData> _categoryIcons = {
  'building': LucideIcons.building,
  'droplets': LucideIcons.droplets,
  'hammer': LucideIcons.hammer,
  'paintbrush': LucideIcons.paintbrush,
  'plug': LucideIcons.plug,
  'snowflake': LucideIcons.snowflake,
  'sparkles': LucideIcons.sparkles,
  'wrench': LucideIcons.wrench,
  'zap': LucideIcons.zap,
};

IconData categoryIcon(String? name) {
  if (name == null || name.isEmpty) return LucideIcons.layoutGrid;
  return _categoryIcons[name] ?? masarIcons[name] ?? LucideIcons.layoutGrid;
}
