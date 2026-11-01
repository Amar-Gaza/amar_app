import 'package:flutter/material.dart';

import '../../../core/theme/app_color_extension.dart';

/// Color pairs shared by state views, banners and chips.
enum StateTone { brand, warning, danger, success, info }

extension StateToneColors on StateTone {
  Color foreground(AppColorExtension colors) => switch (this) {
        StateTone.brand => colors.brand,
        StateTone.warning => colors.warning,
        StateTone.danger => colors.danger,
        StateTone.success => colors.success,
        StateTone.info => colors.info,
      };

  Color background(AppColorExtension colors) => switch (this) {
        StateTone.brand => colors.brandSoft,
        StateTone.warning => colors.warningSoft,
        StateTone.danger => colors.dangerSoft,
        StateTone.success => colors.successSoft,
        StateTone.info => colors.infoSoft,
      };
}
