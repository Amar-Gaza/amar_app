import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/routes/route_args.dart';
import '../../../../controllers/customer/catalog_controller.dart';
import '../../../../controllers/customer/shell_controller.dart';
import '../../../../controllers/shared/session_controller.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/catalog/add_to_cart_flow.dart';
import '../../../widgets/catalog/product_grid_card.dart';
import '../../../widgets/common/empty_view.dart';
import '../../../widgets/common/error_view.dart';
import '../../../widgets/common/section_header.dart';
import '../../../widgets/common/skeleton_list.dart';
import '../../../widgets/home/active_order_card.dart';
import '../../../widgets/home/category_strip.dart';
import '../../../widgets/home/home_header.dart';
import '../../../widgets/home/home_search_field.dart';
import '../../../widgets/home/horizontal_strip.dart';
import '../../../widgets/home/vendor_card.dart';

class HomeTab extends GetView<CatalogController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = Get.find<SessionController>();
    final shell = Get.find<ShellController>();
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Obx(() {
            final user = session.user.value;
            return HomeHeader(
              userName: user?.name,
              avatarUrl: user?.avatarUrl,
              onNotifications: () => shell.select(CustomerTab.notifications),
              onAccount: () => shell.select(CustomerTab.account),
            );
          }),
          HomeSearchField(
            hint: l10n.homeSearchHint,
            onTap: () => Get.toNamed<void>(AppRoutes.search),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: Obx(() {
              final failure = controller.failure.value;
              if (controller.isLoading.value) {
                return const SkeletonList(showSearch: false);
              }
              if (failure != null) {
                return ErrorView(failure: failure, onRetry: controller.load);
              }
              if (controller.isEmpty) {
                return EmptyView(
                  title: l10n.homeEmptyTitle,
                  message: l10n.homeEmptyMessage,
                  actionLabel: l10n.commonRefresh,
                  onAction: controller.load,
                );
              }
              return RefreshIndicator(
                onRefresh: controller.load,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  children: [
                    if (controller.activeOrder.value != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      ActiveOrderCard(
                        order: controller.activeOrder.value!,
                        onTap: () => Get.toNamed<void>(
                          AppRoutes.order,
                          arguments: controller.activeOrder.value!.id,
                        ),
                      ),
                    ],
                    if (controller.categories.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      SectionHeader(
                        title: l10n.homeCategoriesTitle,
                        subtitle: l10n.homeCategoriesSubtitle,
                        actionLabel: l10n.commonViewAll,
                        onAction: () => Get.toNamed<void>(AppRoutes.categories),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      CategoryStrip(
                        categories: controller.categories,
                        onTap: (category) => Get.toNamed<void>(
                          AppRoutes.products,
                          arguments: ProductsArgs(
                            categoryId: category.id,
                            title: category.name.trim(),
                          ),
                        ),
                      ),
                    ],
                    if (controller.vendors.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xl),
                      SectionHeader(
                        title: l10n.homeVendorsTitle,
                        subtitle: l10n.homeVendorsSubtitle,
                        actionLabel: l10n.commonViewAll,
                        onAction: () => Get.toNamed<void>(AppRoutes.vendors),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      HorizontalStrip(
                        items: controller.vendors,
                        height: AppSizes.vendorStripHeight,
                        itemBuilder: (vendor) => VendorCard(
                          vendor: vendor,
                          onTap: () => Get.toNamed<void>(
                            AppRoutes.vendor,
                            arguments: vendor.id,
                          ),
                        ),
                      ),
                    ],
                    if (controller.products.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xl),
                      SectionHeader(
                        title: l10n.homeProductsTitle,
                        subtitle: l10n.homeProductsSubtitle,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      HorizontalStrip(
                        items: controller.products,
                        height: AppSizes.productStripHeight,
                        itemBuilder: (product) => SizedBox(
                          width: AppSizes.productCardWidth,
                          child: ProductGridCard(
                            product: product,
                            onTap: () => Get.toNamed<void>(
                              AppRoutes.product,
                              arguments: ProductArgs(product.id),
                            ),
                            onAdd: () =>
                                AddToCartFlow.quickAdd(context, product),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
