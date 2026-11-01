import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/customer/checkout_controller.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/icon_tile.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/common/primary_button.dart';

/// Saved addresses (design 05).
class AddressPickerScreen extends GetView<CheckoutController> {
  const AddressPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Scaffold(
      appBar: AppTopBar(title: l10n.addressPickerTitle),
      body: Obx(() {
        final failure = controller.addressesFailure.value;
        if (controller.isLoadingAddresses.value &&
            controller.addresses.isEmpty) {
          return const LoadingView();
        }
        if (failure != null && controller.addresses.isEmpty) {
          return ErrorView(
            failure: failure,
            onRetry: controller.loadAddresses,
          );
        }
        final selected = controller.address.value?.id;
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            for (final address in controller.addresses)
              _AddressTile(
                address: address,
                selected: address.id == selected,
                onTap: () => controller.selectAddress(address),
              ),
            Material(
              color: colors.surfaceSoft,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.lgAll,
                side: BorderSide(color: colors.brand),
              ),
              child: InkWell(
                borderRadius: AppRadius.lgAll,
                onTap: () async {
                  final created =
                      await Get.toNamed<Address>(AppRoutes.checkoutAddressNew);
                  if (created != null) controller.addAddress(created);
                },
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.plus, color: colors.brand),
                      const SizedBox(width: AppSpacing.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.addressAddNew,
                            style: context.text.titleSmall,
                          ),
                          Text(
                            l10n.addressInsideZone,
                            style: context.text.labelSmall
                                ?.copyWith(color: colors.mutedText),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: BottomActionBar(
        child: Obx(
          () => PrimaryButton(
            label: l10n.addressUse,
            onPressed: controller.address.value == null ? null : Get.back,
          ),
        ),
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({
    required this.address,
    required this.selected,
    required this.onTap,
  });

  final Address address;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: selected ? colors.surfaceSoft : context.scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: selected ? colors.brand : colors.border),
        ),
        child: InkWell(
          borderRadius: AppRadius.lgAll,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                IconTile(
                  icon: address.isDefault
                      ? LucideIcons.house
                      : LucideIcons.mapPin,
                  size: AppSizes.iconTileSm,
                  iconSize: AppSizes.iconSm,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(address.label ?? '', style: context.text.titleSmall),
                      if (address.details != null)
                        Text(
                          address.details!,
                          style: context.text.labelSmall
                              ?.copyWith(color: colors.mutedText),
                        ),
                    ],
                  ),
                ),
                Icon(
                  selected ? LucideIcons.circleCheck : LucideIcons.circle,
                  color: selected ? colors.brand : colors.subtleText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
