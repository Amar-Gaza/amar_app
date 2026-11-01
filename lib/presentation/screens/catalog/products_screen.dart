import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/routes/route_args.dart';
import '../../../controllers/customer/products_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/catalog/add_to_cart_flow.dart';
import '../../widgets/catalog/cart_button.dart';
import '../../widgets/catalog/catalog_search_field.dart';
import '../../widgets/catalog/product_grid.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/empty_view.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/skeleton_list.dart';

/// Products of a category or vendor (designs 08 and 13A/13B).
class ProductsScreen extends GetView<ProductsController> {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppTopBar(
        title: controller.args.title,
        trailing: const CartButton(),
      ),
      body: Column(
        children: [
          CatalogSearchField(
            hint: l10n.productsSearchHint,
            onSubmitted: controller.search,
          ),
          Expanded(
            child: Obx(() {
              final failure = controller.failure.value;
              if (controller.isLoading.value) {
                return const SkeletonList(showSearch: false);
              }
              if (failure != null) {
                return ErrorView(failure: failure, onRetry: controller.load);
              }
              if (controller.items.isEmpty) {
                return EmptyView(
                  icon: LucideIcons.packageX,
                  title: l10n.productsEmpty,
                  actionLabel: l10n.commonRefresh,
                  onAction: controller.load,
                );
              }
              return RefreshIndicator(
                onRefresh: controller.load,
                child: ProductGrid(
                  products: controller.items.toList(),
                  isLoadingMore: controller.isLoadingMore.value,
                  onEndReached: controller.loadMore,
                  onOpen: (p) => Get.toNamed<void>(
                    AppRoutes.product,
                    arguments: ProductArgs(p.id),
                  ),
                  onAdd: (p) => AddToCartFlow.quickAdd(context, p),
                  header: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      0,
                    ),
                    child: Text(
                      l10n.productsCount(controller.total.value),
                      style: context.text.titleSmall,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
