import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/checkout_controller.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/attachment_tile.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/checkout/checkout_steps.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/field_label.dart';
import '../../widgets/common/icon_tile.dart';
import '../../widgets/common/primary_button.dart';

/// Note and attachments (designs 07, 08, 09A, 09B).
class CheckoutDetailsScreen extends GetView<CheckoutController> {
  const CheckoutDetailsScreen({super.key});

  Future<void> _pick(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.camera),
              title: Text(l10n.attachCamera),
              onTap: () => Navigator.of(sheet).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(LucideIcons.image),
              title: Text(l10n.attachGallery),
              onTap: () => Navigator.of(sheet).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final file = await ImagePicker().pickImage(
      source: source,
      imageQuality: AppDefaults.imageQuality,
    );
    if (file != null) await controller.attach(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Scaffold(
      appBar: AppTopBar(title: l10n.detailsTitle),
      body: Column(
        children: [
          const CheckoutSteps(current: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                AppTextField(
                  controller: controller.note,
                  label: l10n.detailsNote,
                  hint: l10n.detailsNoteHint,
                  maxLength: AppDefaults.orderNoteMax,
                  keyboardType: TextInputType.multiline,
                ),
                if (controller.attachmentsEnabled) ...[
                  const SizedBox(height: AppSpacing.lg),
                  FieldLabel(l10n.attachTitle),
                  Obx(
                    () => Column(
                      children: [
                        for (final item in controller.attachments)
                          AttachmentTile(
                            item: item,
                            onRetry: () => controller.retryUpload(item),
                            onRemove: () => controller.removeAttachment(item),
                          ),
                        if (controller.attachments.length <
                            AppDefaults.maxAttachments)
                          Material(
                            color: colors.surfaceSoft,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.lgAll,
                              side: BorderSide(color: colors.brand),
                            ),
                            child: InkWell(
                              borderRadius: AppRadius.lgAll,
                              onTap: () => _pick(context),
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.xl),
                                child: Column(
                                  children: [
                                    const IconTile(icon: LucideIcons.upload),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      l10n.attachPick,
                                      style: context.text.titleSmall,
                                    ),
                                    Text(
                                      l10n.attachLimits(
                                        AppDefaults.maxAttachments,
                                      ),
                                      style: context.text.labelSmall?.copyWith(
                                        color: colors.mutedText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: Obx(
          () => PrimaryButton(
            label: controller.hasPendingUploads
                ? l10n.attachUploading
                : l10n.commonContinue,
            onPressed: controller.hasPendingUploads ? null : Get.back,
          ),
        ),
      ),
    );
  }
}
