import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/vendor_application_controller.dart';
import '../../../controllers/shared/app_config_controller.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/checkout/label_value_row.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/field_label.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_tone.dart';
import '../../widgets/common/state_view.dart';
import '../../widgets/orders/section_card.dart';

/// Vendor application form and result (account designs 11, 12).
class VendorApplicationScreen extends GetView<VendorApplicationController> {
  const VendorApplicationScreen({super.key});

  List<String> get _categories {
    final raw = Get.find<AppConfigController>()
        .config
        .value
        ?.modulesConfig[ApiModules.vendors];
    final list = raw is Map ? raw['categories'] : null;
    return list is List ? list.map((e) => '$e').toList() : const [];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Obx(() {
      final result = controller.result.value;
      if (result != null) {
        return Scaffold(
          appBar: AppTopBar(title: l10n.vendorApplyTitle),
          body: StateView(
            icon: LucideIcons.circleCheck,
            tone: StateTone.success,
            title: l10n.vendorApplySentTitle,
            message: l10n.vendorApplySentMessage,
            primaryLabel: l10n.successBackHome,
            onPrimary: () => Get.back<void>(),
            footer: SectionCard(
              children: [
                LabelValueRow(
                  label: l10n.vendorApplyBusiness,
                  value: result.businessName,
                ),
                LabelValueRow(
                  label: l10n.successStatus,
                  value: result.status,
                ),
              ],
            ),
          ),
        );
      }
      final errors = controller.showErrors.value;
      final failure = controller.failure.value;
      return Scaffold(
        appBar: AppTopBar(title: l10n.vendorApplyTitle),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(l10n.vendorApplyIntro, style: context.text.bodySmall),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: controller.business,
              label: l10n.vendorApplyBusiness,
              hint: l10n.vendorApplyBusinessHint,
              prefixIcon: LucideIcons.store,
              errorText: errors && controller.businessMissing
                  ? l10n.commonRequired
                  : null,
            ),
            AppTextField(
              controller: controller.contact,
              label: l10n.vendorApplyContact,
              hint: l10n.profileNameHint,
              prefixIcon: LucideIcons.user,
              errorText: errors && controller.contactMissing
                  ? l10n.commonRequired
                  : null,
            ),
            AppTextField(
              controller: controller.phone,
              label: l10n.phoneLabel,
              hint: l10n.phoneHint,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              prefixIcon: LucideIcons.phone,
              errorText: errors && controller.phoneInvalid
                  ? l10n.validationPhoneInvalid
                  : null,
            ),
            if (_categories.isNotEmpty) ...[
              FieldLabel(l10n.productCategory),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final category in _categories)
                    ChoiceChip(
                      label: Text(category),
                      selected: controller.category.value == category,
                      onSelected: (_) => controller.category.value = category,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            AppTextField(
              controller: controller.note,
              label: l10n.detailsNote,
              hint: l10n.detailsNoteHint,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: controller.includeLocation.value,
              onChanged: (v) => controller.includeLocation.value = v,
              title: Text(
                l10n.vendorApplyLocation,
                style: context.text.titleSmall,
              ),
            ),
            if (failure != null) ErrorBanner(failure: failure),
          ],
        ),
        bottomNavigationBar: BottomActionBar(
          child: PrimaryButton(
            label: l10n.vendorApplySubmit,
            isLoading: controller.isSubmitting.value,
            onPressed: controller.submit,
          ),
        ),
      );
    });
  }
}
