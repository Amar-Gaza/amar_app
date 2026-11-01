import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/routes/route_args.dart';
import '../../../controllers/customer/catalog_controller.dart';
import '../../../controllers/customer/product_controller.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/catalog/add_to_cart_flow.dart';
import '../../widgets/catalog/cover_back_button.dart';
import '../../widgets/catalog/info_box.dart';
import '../../widgets/catalog/quantity_stepper.dart';
import '../../widgets/common/code_chip.dart';
import '../../widgets/common/directional_icons.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/icon_tile.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/common/network_thumb.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_tone.dart';

/// Product page (designs 09 and 12 — out of stock).
class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  static const double _imageHeight = 300;
  static const double _inspectionAlpha = 0.6;

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as ProductArgs;
    final controller = Get.find<ProductController>(tag: args.tag);
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Obx(() {
      final product = controller.product.value;
      final failure = controller.failure.value;
      if (product == null && failure != null) {
        return Scaffold(
          body: SafeArea(
            child: ErrorView(failure: failure, onRetry: controller.load),
          ),
        );
      }
      if (product == null) return const Scaffold(body: LoadingView());
      final available = product.inStock;
      final vendorName = controller.vendor.value?.name;
      final categoryName = Get.isRegistered<CatalogController>()
          ? Get.find<CatalogController>()
              .categories
              .firstWhereOrNull((c) => c.id == product.categoryId)
              ?.name
              .trim()
          : null;
      return Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                NetworkThumb(url: product.imageUrl, height: _imageHeight),
                const CoverBackButton(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: CodeChip(
                      label: available
                          ? l10n.productAvailable
                          : l10n.productUnavailableNow,
                      tone: available ? StateTone.success : StateTone.danger,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(product.name, style: context.text.headlineMedium),
                  if (product.description != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(product.description!, style: context.text.bodySmall),
                  ],
                  if (vendorName != null || categoryName != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        if (vendorName != null)
                          Expanded(
                            child: InfoBox(
                              label: l10n.productVendor,
                              value: vendorName,
                            ),
                          ),
                        if (vendorName != null && categoryName != null)
                          const SizedBox(width: AppSpacing.sm),
                        if (categoryName != null)
                          Expanded(
                            child: InfoBox(
                              label: l10n.productCategory,
                              value: categoryName,
                            ),
                          ),
                      ],
                    ),
                  ],
                  const Divider(height: AppSpacing.xxl),
                  Text(
                    product.priceMode == ProductPriceMode.inspection
                        ? l10n.productPriceAfterInspection
                        : l10n.productIndicativePrice,
                    style: context.text.labelSmall
                        ?.copyWith(color: colors.mutedText),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        product.price.formatted,
                        style: context.text.headlineSmall?.copyWith(
                          color: product.priceMode ==
                                  ProductPriceMode.inspection
                              ? colors.brand.withValues(alpha: _inspectionAlpha)
                              : colors.brand,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      if (product.compareAtPrice != null)
                        Text(
                          product.compareAtPrice!.formatted,
                          style: context.text.labelMedium?.copyWith(
                            color: colors.subtleText,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (!available) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: colors.dangerSoft,
                        borderRadius: AppRadius.lgAll,
                      ),
                      child: Row(
                        children: [
                          IconTile(
                            icon: LucideIcons.packageX,
                            background: context.scheme.surface,
                            foreground: colors.danger,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.productOutOfStockTitle,
                                  style: context.text.titleSmall
                                      ?.copyWith(color: colors.danger),
                                ),
                                Text(
                                  l10n.productOutOfStockMessage,
                                  style: context.text.labelSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (product.categoryId != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      OutlinedButton(
                        onPressed: () => Get.offNamed<void>(
                          AppRoutes.products,
                          arguments: ProductsArgs(
                            categoryId: product.categoryId,
                            title: categoryName ?? l10n.productAlternatives,
                          ),
                        ),
                        child: Text(l10n.productAlternatives),
                      ),
                    ],
                  ] else if (controller.hasOptions)
                    Material(
                      color: context.scheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.lgAll,
                        side: BorderSide(color: colors.border),
                      ),
                      child: ListTile(
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.lgAll,
                        ),
                        title: Text(
                          l10n.productOptionsTitle,
                          style: context.text.titleSmall,
                        ),
                        subtitle: Text(
                          l10n.productOptionsHint,
                          style: context.text.labelSmall,
                        ),
                        trailing: Icon(DirectionalIcons.forward(context)),
                        onTap: () => Get.toNamed<void>(
                          AppRoutes.productOptions,
                          arguments: args,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: !available
                ? FilledButton(
                    onPressed: null,
                    style: FilledButton.styleFrom(
                      disabledBackgroundColor: colors.skeleton,
                      disabledForegroundColor: colors.subtleText,
                    ),
                    child: Text(l10n.productUnavailable),
                  )
                : Row(
                    children: [
                      QuantityStepper(
                        value: controller.qty.value,
                        onIncrement: controller.increment,
                        onDecrement:
                            controller.qty.value > ProductController.minQty
                                ? controller.decrement
                                : null,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: PrimaryButton(
                          label: l10n.cartAdd,
                          onPressed: () async {
                            if (controller.missingRequired) {
                              await Get.toNamed<void>(
                                AppRoutes.productOptions,
                                arguments: args,
                              );
                              return;
                            }
                            final added = await AddToCartFlow.fromProduct(
                              context,
                              controller,
                            );
                            if (added) controller.qty.value = 1;
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}

abstract final class ProductPriceMode {
  static const String fixed = 'fixed';
  static const String inspection = 'inspection';
}
