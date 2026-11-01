import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/driver/driver_order_controller.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/field_label.dart';
import '../../widgets/common/primary_button.dart';
import 'driver_order_screen.dart';

/// Inputs the next action requires: photo, code, fields (designs 19, 20).
class DriverActionSheet extends GetView<DriverOrderController> {
  const DriverActionSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const DriverActionSheet(),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final next = controller.next!;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(next.label, style: context.text.headlineSmall),
            if (next.confirm != null)
              Text(next.confirm!, style: context.text.bodySmall),
            const SizedBox(height: AppSpacing.lg),
            if (controller.needsPhoto) ...[
              FieldLabel(l10n.driverProofPhoto),
              Obx(() {
                final path = controller.photoPath.value;
                return InkWell(
                  borderRadius: AppRadius.lgAll,
                  onTap: () async {
                    final picked = await pickProofPhoto();
                    if (picked != null) controller.photoPath.value = picked;
                  },
                  child: Container(
                    height: proofPreview,
                    decoration: BoxDecoration(
                      color: colors.surfaceSoft,
                      borderRadius: AppRadius.lgAll,
                      border: Border.all(color: colors.brand),
                      image: path == null
                          ? null
                          : DecorationImage(
                              image: FileImage(File(path)),
                              fit: BoxFit.cover,
                            ),
                    ),
                    child: path == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.camera, color: colors.brand),
                              Text(l10n.attachCamera),
                            ],
                          )
                        : null,
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.md),
            ],
            if (controller.needsOtp)
              AppTextField(
                controller: controller.otp,
                label: l10n.driverDeliveryCode,
                hint: l10n.driverDeliveryCodeHint,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
              ),
            for (final key in next.fields)
              AppTextField(
                controller: controller.field(key),
                label: key,
                hint: key,
              ),
            AppTextField(
              controller: controller.note,
              label: l10n.detailsNote,
              hint: l10n.detailsNoteHint,
            ),
            const SizedBox(height: AppSpacing.md),
            Obx(
              () => PrimaryButton(
                label: next.label,
                isLoading: controller.isBusy.value,
                onPressed: controller.needsPhoto &&
                        controller.photoPath.value == null
                    ? null
                    : () async {
                        final ok = await controller.runNext();
                        if (ok && context.mounted) Navigator.of(context).pop();
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
