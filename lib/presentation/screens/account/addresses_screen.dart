import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/customer/addresses_controller.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/code_chip.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/common/empty_view.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/icon_tile.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/skeleton_list.dart';
import '../../widgets/common/state_tone.dart';

/// Saved addresses with add, edit and delete (account designs 03–06).
class AddressesScreen extends GetView<AddressesController> {
  const AddressesScreen({super.key});

  Future<void> _form([Address? address]) async {
    final saved = await Get.toNamed<Address>(
      AppRoutes.addressForm,
      arguments: address,
    );
    if (saved != null) await controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Scaffold(
      appBar: AppTopBar(title: l10n.accountAddresses),
      body: Obx(() {
        final failure = controller.failure.value;
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const SkeletonList(showSearch: false);
        }
        if (failure != null && controller.items.isEmpty) {
          return ErrorView(failure: failure, onRetry: controller.load);
        }
        if (controller.items.isEmpty) {
          return EmptyView(
            icon: LucideIcons.mapPin,
            title: l10n.addressesEmpty,
            actionLabel: l10n.addressAddNew,
            onAction: _form,
          );
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            for (final address in controller.items)
              Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.lgAll,
                  border: Border.all(color: colors.border),
                ),
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
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  address.label ?? '',
                                  style: context.text.titleSmall,
                                ),
                              ),
                              if (address.isDefault) ...[
                                const SizedBox(width: AppSpacing.sm),
                                CodeChip(
                                  label: l10n.addressDefault,
                                  tone: StateTone.brand,
                                ),
                              ],
                            ],
                          ),
                          if (address.details != null)
                            Text(
                              address.details!,
                              style: context.text.labelSmall
                                  ?.copyWith(color: colors.mutedText),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.addressEditTitle,
                      onPressed: () => _form(address),
                      icon: Icon(LucideIcons.pencil, color: colors.brand),
                    ),
                    IconButton(
                      tooltip: l10n.cartRemove,
                      onPressed: () async {
                        final ok = await ConfirmationDialog.show(
                          context,
                          l10n.addressDeleteConfirm,
                        );
                        if (ok) await controller.delete(address);
                      },
                      icon: Icon(LucideIcons.trash2, color: colors.danger),
                    ),
                  ],
                ),
              ),
          ],
        );
      }),
      bottomNavigationBar: BottomActionBar(
        child: PrimaryButton(label: l10n.addressAddNew, onPressed: _form),
      ),
    );
  }
}
