import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../common/dashed_painter.dart';

/// Dashed "take a photo" button; turns solid with a thumbnail once a
/// proof photo is attached. Tapping again retakes it.
class ProofPhotoButton extends StatelessWidget {
  const ProofPhotoButton({super.key, required this.path, required this.onTap});

  static const double _height = 60;

  final String? path;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final file = path;
    final done = file != null;
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (done)
          ClipRRect(
            borderRadius: AppRadius.smAll,
            child: Image.file(
              File(file),
              width: AppSizes.iconXl,
              height: AppSizes.iconXl,
              fit: BoxFit.cover,
            ),
          )
        else
          Icon(LucideIcons.camera, size: AppSizes.iconSm, color: colors.brand),
        const SizedBox(width: AppSpacing.sm),
        Text(
          done ? l10n.driverPhotoAttached : l10n.driverTakePhoto,
          style: context.text.titleMedium?.copyWith(color: colors.brand),
        ),
        if (done) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(
            LucideIcons.circleCheck,
            size: AppSizes.iconSm,
            color: colors.brandBright,
          ),
        ],
      ],
    );
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lgAll,
        child: done
            ? Container(
                height: _height,
                decoration: BoxDecoration(
                  color: colors.successSoft,
                  borderRadius: AppRadius.lgAll,
                  border: Border.all(
                    color: colors.brandBright,
                    width: AppSizes.borderWidthField,
                  ),
                ),
                child: content,
              )
            : CustomPaint(
                painter: DashedPainter(
                  color: colors.subtleText,
                  radius: AppRadius.lg,
                  strokeWidth: AppSizes.borderWidthField,
                ),
                child: Container(
                  height: _height,
                  decoration: BoxDecoration(
                    color: colors.surfaceSoft,
                    borderRadius: AppRadius.lgAll,
                  ),
                  child: content,
                ),
              ),
      ),
    );
  }
}
