import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/routes/route_args.dart';
import '../../../controllers/customer/catalog_search_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/catalog/add_to_cart_flow.dart';
import '../../widgets/catalog/cart_button.dart';
import '../../widgets/catalog/catalog_search_field.dart';
import '../../widgets/catalog/product_grid.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/skeleton_list.dart';
import '../../widgets/common/state_view.dart';

/// Product search (designs 02 and 03).
class SearchScreen extends GetView<CatalogSearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppTopBar(
        title: l10n.searchTitle,
        trailing: const CartButton(),
      ),
      body: Column(
        children: [
          CatalogSearchField(
            hint: l10n.searchHint,
            controller: controller.input,
            autofocus: true,
            onSubmitted: controller.submit,
          ),
          Expanded(
            child: Obx(() {
              final failure = controller.failure.value;
              if (!controller.hasQuery) {
                return StateView(
                  icon: LucideIcons.search,
                  title: l10n.searchIdleTitle,
                  message: l10n.searchIdleMessage,
                  primaryLabel: l10n.searchBrowseCategories,
                  onPrimary: () => Get.toNamed<void>(AppRoutes.categories),
                );
              }
              if (controller.isLoading.value) {
                return const SkeletonList(showSearch: false);
              }
              if (failure != null) {
                return ErrorView(failure: failure, onRetry: controller.load);
              }
              if (controller.items.isEmpty) {
                return StateView(
                  icon: LucideIcons.searchX,
                  title: l10n.searchEmptyTitle,
                  message: l10n.searchEmptyMessage,
                  primaryLabel: l10n.searchBrowseCategories,
                  onPrimary: () => Get.toNamed<void>(AppRoutes.categories),
                  secondaryLabel: l10n.searchClear,
                  onSecondary: controller.clearQuery,
                );
              }
              return ProductGrid(
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.searchResultsTitle,
                          style: context.text.titleSmall,
                        ),
                      ),
                      Text(
                        l10n.resultsCount(controller.total.value),
                        style: context.text.labelSmall?.copyWith(
                          color: context.appColors.mutedText,
                        ),
                      ),
                    ],
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
