import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/routes/route_args.dart';
import '../../../controllers/customer/product_controller.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/cart/cart_item.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/catalog/add_to_cart_flow.dart';
import '../../widgets/catalog/cart_button.dart';
import '../../widgets/catalog/quantity_stepper.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/info_banner.dart';
import '../../widgets/common/network_thumb.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_tone.dart';

/// Quantity and add to cart (design 11).
class ProductQuantityScreen extends StatelessWidget {
  const ProductQuantityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as ProductArgs;
    final controller = Get.find<ProductController>(tag: args.tag);
    final product = controller.product.value!;
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final choices = CartItem(
      product: product,
      qty: 1,
      options: Map<String, List<String>>.from(controller.selections),
    ).choiceLabels;
    return Scaffold(
      appBar: AppTopBar(
        title: l10n.quantityTitle,
        trailing: const CartButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: AppRadius.lgAll,
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: AppRadius.mdAll,
                  child: SizedBox.square(
                    dimension: AppSizes.productImage,
                    child: NetworkThumb(url: product.imageUrl),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: context.text.titleLarge),
                      if (choices.isNotEmpty)
                        Text(
                          choices.join(' · '),
                          style: context.text.labelSmall
                              ?.copyWith(color: colors.mutedText),
                        ),
                      Text(
                        l10n.quantityServerPriced,
                        style: context.text.labelSmall
                            ?.copyWith(color: colors.brand),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.huge),
          Center(
            child: Obx(
              () => QuantityStepper(
                large: true,
                value: controller.qty.value,
                onIncrement: controller.maxQty == null ||
                        controller.qty.value < controller.maxQty!
                    ? controller.increment
                    : null,
                onDecrement: controller.qty.value > ProductController.minQty
                    ? controller.decrement
                    : null,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: Text(
              l10n.quantityLabel,
              style: context.text.labelSmall?.copyWith(color: colors.mutedText),
            ),
          ),
          const SizedBox(height: AppSpacing.huge),
          if (controller.maxQty != null) ...[
            InfoBanner(
              icon: LucideIcons.boxes,
              tone: StateTone.brand,
              title: l10n.quantityStock(controller.maxQty!),
              message: l10n.quantityStockHint,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          InfoBanner(
            icon: LucideIcons.info,
            tone: StateTone.warning,
            title: l10n.quantityPriceNote,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Obx(
            () => PrimaryButton(
              label: l10n.cartAddCount(controller.qty.value),
              onPressed: () async {
                final added =
                    await AddToCartFlow.fromProduct(context, controller);
                if (!added) return;
                controller.qty.value = ProductController.minQty;
                Get.until((route) => route.settings.name == AppRoutes.product);
              },
            ),
          ),
        ),
      ),
    );
  }
}
