
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/customer/address_form_controller.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/constants/app_env.dart';
import '../../../core/localization/location_issue_text.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/catalog/picked_location.dart';
import '../../../data/services/shared/device_location_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/info_banner.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_tone.dart';

class AddressFormScreen
    extends GetView<AddressFormController> {
  const AddressFormScreen({super.key});

  static const double _mapHeight = 220;
  static const int _coordDigits = 5;

  Future<void> _pickOnMap() async {
    final hasPosition = controller.hasPosition;

    final picked = await Get.toNamed<PickedLocation>(
      AppRoutes.mapPicker,
      arguments: hasPosition
          ? PickedLocation(
        lat: controller.lat.value!,
        lng: controller.lng.value!,
      )
          : null,
    );

    if (picked != null) {
      await controller.setPosition(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;

    return Scaffold(
      appBar: AppTopBar(
        title: controller.isEditing
            ? l10n.addressEditTitle
            : l10n.addressNewTitle,
      ),
      body: ListView(
        padding:
        const EdgeInsets.all(AppSpacing.lg),
        children: [
          Obx(() {
            final issue =
                controller.locationIssue.value;

            return Container(
              height: _mapHeight,
              decoration: BoxDecoration(
                color: colors.surfaceSoft,
                borderRadius: AppRadius.lgAll,
              ),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius:
                    AppSizes.iconTileSm / 2,
                    backgroundColor: colors.brand,
                    child: controller.isLocating.value
                        ? SizedBox.square(
                      dimension:
                      AppSizes.iconSm,
                      child:
                      CircularProgressIndicator(
                        strokeWidth:
                        AppSizes.loaderStroke,
                        color: colors.onBrand,
                      ),
                    )
                        : Icon(
                      LucideIcons.mapPin,
                      color: colors.onBrand,
                    ),
                  ),

                  const SizedBox(
                    height: AppSpacing.sm,
                  ),

                  Text(
                    controller
                        .addressUnavailable.value
                        ? l10n
                        .locationAddressUnavailable
                        : controller.hasPosition
                        ? l10n.addressLocated
                        : issue != null
                        ? LocationIssueText
                        .of(l10n, issue)
                        : l10n
                        .addressLocating,
                    textAlign: TextAlign.center,
                    style: context.text.titleSmall,
                  ),

                  if (controller.hasPosition)
                    Text(
                      '${controller.lat.value!.toStringAsFixed(_coordDigits)}, '
                          '${controller.lng.value!.toStringAsFixed(_coordDigits)}',
                      textDirection:
                      TextDirection.ltr,
                      style: context.text.labelSmall
                          ?.copyWith(
                        color: colors.mutedText,
                      ),
                    ),

                  TextButton.icon(
                    onPressed: issue ==
                        LocationIssue.deniedForever
                        ? controller.openSettings
                        : issue ==
                        LocationIssue
                            .serviceDisabled
                        ? controller
                        .openLocationSettings
                        : controller.locate,
                    icon: const Icon(
                      LucideIcons.locateFixed,
                    ),
                    label: Text(
                      issue ==
                          LocationIssue
                              .deniedForever ||
                          issue ==
                              LocationIssue
                                  .serviceDisabled
                          ? l10n
                          .locationOpenSettings
                          : l10n
                          .addressUseMyLocation,
                    ),
                  ),

                  if (AppEnv.hasMaps)
                    TextButton.icon(
                      onPressed: _pickOnMap,
                      icon: const Icon(
                        LucideIcons.map,
                      ),
                      label: Text(
                        l10n.addressPickOnMap,
                      ),
                    ),
                ],
              ),
            );
          }),

          Obx(
                () => controller.positionMissing.value
                ? Padding(
              padding:
              const EdgeInsets.only(
                top: AppSpacing.sm,
              ),
              child: InfoBanner(
                icon: LucideIcons.mapPin,
                tone: StateTone.warning,
                title:
                l10n.addressPickOnMap,
              ),
            )
                : const SizedBox.shrink(),
          ),

          const SizedBox(
            height: AppSpacing.lg,
          ),

          Obx(
                () => AppTextField(
              controller: controller.label,
              label: l10n.addressLabel,
              hint: l10n.addressLabelHint,
              maxLength:
              AppDefaults.addressLabelMax,
              errorText:
              controller.labelMissing.value
                  ? l10n.addressLabelRequired
                  : null,
            ),
          ),

          const SizedBox(
            height: AppSpacing.sm,
          ),

          AppTextField(
            controller: controller.details,
            label: l10n.addressDetails,
            hint: l10n.addressDetailsHint,
            maxLength:
            AppDefaults.addressDetailsMax,
          ),

          const SizedBox(
            height: AppSpacing.sm,
          ),

          Obx(
                () => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: controller.isDefault.value,
              onChanged: (value) {
                controller.isDefault.value =
                    value;
              },
              title: Text(
                l10n.addressMakeDefault,
                style: context.text.titleSmall,
              ),
            ),
          ),

          const SizedBox(
            height: AppSpacing.sm,
          ),

          InfoBanner(
            icon: LucideIcons.mapPin,
            tone: StateTone.warning,
            title: l10n.addressZoneNote,
          ),

          Obx(() {
            final failure =
                controller.failure.value;

            if (failure == null) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.md,
              ),
              child: ErrorBanner(
                failure: failure,
              ),
            );
          }),
        ],
      ),

      bottomNavigationBar: BottomActionBar(
        child: Obx(
              () => PrimaryButton(
            label: l10n.addressSave,
            isLoading:
            controller.isSaving.value,
            onPressed: () async {
              final created =
              await controller.save();

              if (created != null) {
                Get.back(result: created);
              }
            },
          ),
        ),
      ),
    );
  }
}
