import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/driver/driver_profile_controller.dart';
import '../../../controllers/driver/driver_session_controller.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/avatar_initial.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/field_label.dart';
import '../../widgets/common/language_sheet.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/select_row.dart';

/// Edit driver profile (design 32).
class DriverProfileScreen extends GetView<DriverProfileController> {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final driver = Get.find<DriverSessionController>().driver.value;
    return Scaffold(
      appBar: AppTopBar(title: l10n.accountEditProfile),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: Obx(() {
              final path = controller.avatarPath.value;
              return GestureDetector(
                onTap: () async {
                  final file = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: AppDefaults.imageQuality,
                  );
                  if (file != null) controller.avatarPath.value = file.path;
                },
                child: path == null
                    ? AvatarInitial(
                        name: driver?.name,
                        imageUrl: driver?.avatarUrl,
                        size: AppSizes.avatarLg,
                      )
                    : CircleAvatar(
                        radius: AppSizes.avatarLg / 2,
                        backgroundImage: FileImage(File(path)),
                      ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.xl),
          FieldLabel(l10n.profileLanguageLabel),
          Obx(
            () => SelectRow(
              value: LanguageSheet.label(l10n, controller.language.value),
              onTap: () async {
                final picked = await LanguageSheet.show(
                    context, controller.language.value);
                if (picked != null) controller.language.value = picked;
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FieldLabel(l10n.driverVehicle),
          Obx(
            () => Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final type in VehicleTypes.all)
                  ChoiceChip(
                    avatar:
                        const Icon(LucideIcons.truck, size: AppSizes.iconXs),
                    label: Text(type),
                    selected: controller.vehicle.value == type,
                    onSelected: (_) => controller.vehicle.value = type,
                  ),
              ],
            ),
          ),
          Obx(() {
            final failure = controller.failure.value;
            return failure == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: ErrorBanner(failure: failure),
                  );
          }),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: Obx(
          () => PrimaryButton(
            label: l10n.commonSave,
            isLoading: controller.isSaving.value,
            onPressed: () async {
              if (await controller.save()) Get.back<void>();
            },
          ),
        ),
      ),
    );
  }
}
