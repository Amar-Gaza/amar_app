import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/address_form_controller.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/services/shared/device_location_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/info_banner.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_tone.dart';

/// New delivery address from the device position (design 06).
class AddressFormScreen extends GetView<AddressFormController> {
  const AddressFormScreen({super.key});

  static const double _mapHeight = 170;
  static const int _coordDigits = 5;

  String _issue(AppLocalizations l10n, LocationIssue issue) => switch (issue) {
        LocationIssue.serviceDisabled => l10n.locationServiceOff,
        LocationIssue.denied => l10n.locationDenied,
        LocationIssue.deniedForever => l10n.locationDeniedForever,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Scaffold(
      appBar: AppTopBar(
        title:
            controller.isEditing ? l10n.addressEditTitle : l10n.addressNewTitle,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Obx(() {
            final issue = controller.locationIssue.value;
            return Container(
              height: _mapHeight,
              decoration: BoxDecoration(
                color: colors.surfaceSoft,
                borderRadius: AppRadius.lgAll,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: AppSizes.iconTileSm / 2,
                    backgroundColor: colors.brand,
                    child: controller.isLocating.value
                        ? SizedBox.square(
                            dimension: AppSizes.iconSm,
                            child: CircularProgressIndicator(
                              strokeWidth: AppSizes.loaderStroke,
                              color: colors.onBrand,
                            ),
                          )
                        : Icon(LucideIcons.mapPin, color: colors.onBrand),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    controller.hasPosition
                        ? l10n.addressLocated
                        : issue != null
                            ? _issue(l10n, issue)
                            : l10n.addressLocating,
                    textAlign: TextAlign.center,
                    style: context.text.titleSmall,
                  ),
                  if (controller.hasPosition)
                    Text(
                      '${controller.lat.value!.toStringAsFixed(_coordDigits)}, '
                      '${controller.lng.value!.toStringAsFixed(_coordDigits)}',
                      textDirection: TextDirection.ltr,
                      style: context.text.labelSmall
                          ?.copyWith(color: colors.mutedText),
                    ),
                  TextButton.icon(
                    onPressed: issue == LocationIssue.deniedForever
                        ? controller.openSettings
                        : controller.locate,
                    icon: const Icon(LucideIcons.locateFixed),
                    label: Text(
                      issue == LocationIssue.deniedForever
                          ? l10n.locationOpenSettings
                          : l10n.addressUseMyLocation,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: AppSpacing.lg),
          Obx(
            () => AppTextField(
              controller: controller.label,
              label: l10n.addressLabel,
              hint: l10n.addressLabelHint,
              maxLength: AppDefaults.addressLabelMax,
              errorText: controller.labelMissing.value
                  ? l10n.addressLabelRequired
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            controller: controller.details,
            label: l10n.addressDetails,
            hint: l10n.addressDetailsHint,
            maxLength: AppDefaults.addressDetailsMax,
          ),
          const SizedBox(height: AppSpacing.sm),
          Obx(
            () => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: controller.isDefault.value,
              onChanged: (value) => controller.isDefault.value = value,
              title:
                  Text(l10n.addressMakeDefault, style: context.text.titleSmall),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          InfoBanner(
            icon: LucideIcons.mapPin,
            tone: StateTone.warning,
            title: l10n.addressZoneNote,
          ),
          Obx(() {
            final failure = controller.failure.value;
            if (failure == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: ErrorBanner(failure: failure),
            );
          }),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: Obx(
          () => PrimaryButton(
            label: l10n.addressSave,
            isLoading: controller.isSaving.value,
            onPressed: controller.hasPosition
                ? () async {
                    final created = await controller.save();
                    if (created != null) Get.back(result: created);
                  }
                : null,
          ),
        ),
      ),
    );
  }
}
