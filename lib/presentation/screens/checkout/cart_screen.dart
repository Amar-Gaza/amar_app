import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/customer/cart_controller.dart';
import '../../../controllers/customer/checkout_controller.dart';
import '../../../controllers/customer/shell_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/checkout/cart_line_card.dart';
import '../../widgets/checkout/checkout_steps.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/empty_view.dart';
import '../../widgets/common/info_banner.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_tone.dart';
import '../../widgets/common/icon_tile.dart';
import '../../../core/theme/app_sizes.dart';

/// Cart overview with inline editing (designs 01–03).
class CartScreen extends GetView<CheckoutController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cart = Get.find<CartController>();
    final colors = context.appColors;
    return Obx(() {
      if (cart.items.isEmpty) {
        return Scaffold(
          appBar: AppTopBar(title: l10n.cartTitle, showBack: false),
          body: EmptyView(
            icon: LucideIcons.shoppingCart,
            title: l10n.cartEmptyTitle,
            message: l10n.cartEmptyMessage,
            actionLabel: l10n.ordersExplore,
            onAction: () =>
                Get.find<ShellController>().select(CustomerTab.home),
          ),
        );
      }
      final vendor = controller.vendor.value;
      return Scaffold(
        appBar: AppTopBar(title: l10n.cartTitle, showBack: false),
        body: Column(
          children: [
            const CheckoutSteps(current: 0),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  Row(
                    children: [
                      IconTile(
                        icon: LucideIcons.store,
                        size: AppSizes.iconTileSm,
                        iconSize: AppSizes.iconSm,
                        background: colors.accent,
                        foreground: colors.ink,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vendor?.name ?? l10n.cartVendorFallback,
                              style: context.text.titleMedium,
                            ),
                            Text(
                              l10n.cartLinesCount(cart.items.length),
                              style: context.text.labelSmall
                                  ?.copyWith(color: colors.mutedText),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: cart.clear,
                        child: Text(
                          l10n.cartClear,
                          style: TextStyle(color: colors.danger),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: AppSpacing.xl),
                  for (final item in cart.items) ...[
                    CartLineCard(
                      item: item,
                      onQtyChanged: (qty) => cart.setQty(item, qty),
                      onRemove: () => cart.remove(item),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  InfoBanner(
                    icon: LucideIcons.banknote,
                    tone: StateTone.brand,
                    title: l10n.cartTotalNote,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomActionBar(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.cartTotalLabel,
                      style: context.text.labelSmall
                          ?.copyWith(color: colors.mutedText),
                    ),
                    Text(
                      l10n.cartTotalLater,
                      style: context.text.titleSmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: l10n.commonContinue,
                  onPressed: () =>
                      Get.toNamed<void>(AppRoutes.checkoutDelivery),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
