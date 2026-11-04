import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/routes/route_args.dart';
import '../../../../controllers/customer/catalog_controller.dart';
import '../../../../controllers/customer/notifications_controller.dart';
import '../../../../controllers/shared/app_config_controller.dart';
import '../../../../data/services/shared/device_location_service.dart';
import '../../../../core/constants/api_query.dart';
import '../../../../core/localization/location_issue_text.dart';
import '../../../../core/constants/app_defaults.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/catalog/add_to_cart_flow.dart';
import '../../../widgets/common/empty_view.dart';
import '../../../widgets/common/error_view.dart';
import '../../../widgets/common/section_header.dart';
import '../../../widgets/common/skeleton_list.dart';
import '../../../widgets/home/active_order_card.dart';
import '../../../widgets/home/category_grid.dart';
import '../../../widgets/home/current_location_sheet.dart';
import '../../../widgets/home/home_header.dart';
import '../../../widgets/home/home_product_card.dart';
import '../../../widgets/home/home_search_field.dart';
import '../../../widgets/home/horizontal_strip.dart';
import '../../../widgets/home/promo_banner.dart';
import '../../../widgets/home/provider_section.dart';

class HomeTab extends GetView<CatalogController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final notifications = Get.find<NotificationsController>();
    final config = Get.find<AppConfigController>();

    const sectionGap = SizedBox(height: AppSpacing.page);
    const headerGap = SizedBox(height: AppSpacing.sm);

    const sidePadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.page,
    );

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Obx(() {
            final location =
            Get.find<DeviceLocationService>();
            final issue = location.issue.value;
            final currentLabel =
                location.resolvedLocation.value?.label;

            return HomeHeader(
              hasUnread: notifications.hasUnread,
              locationLabel:
              currentLabel ??
                  (location.isLocating.value
                      ? l10n.addressLocating
                      : issue != null
                      ? LocationIssueText.of(l10n, issue)
                      : location.currentPoint.value != null
                      ? l10n.locationAddressUnavailable
                      : l10n.homeSetLocation),
              onNotifications: () => Get.toNamed<void>(
                AppRoutes.notifications,
              ),
              onLocation: () =>
                  CurrentLocationSheet.show(context, l10n),
            );
          }),
          const SizedBox(height: AppSpacing.md),
          HomeSearchField(
            hint: l10n.homeSearchHint,
            onTap: () => Get.toNamed<void>(
              AppRoutes.search,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: Obx(() {
              final failure = controller.failure.value;

              if (controller.isLoading.value) {
                return const SkeletonList(
                  showSearch: false,
                );
              }

              if (failure != null) {
                return ErrorView(
                  failure: failure,
                  onRetry: controller.load,
                );
              }

              if (controller.isEmpty) {
                return EmptyView(
                  title: l10n.homeEmptyTitle,
                  message: l10n.homeEmptyMessage,
                  actionLabel: l10n.commonRefresh,
                  onAction: controller.load,
                );
              }

              final order = controller.activeOrder.value;

              final (totalSteps, currentStep) = order == null
                  ? (0, 0)
                  : config.progressOf(order.status.key);

              return RefreshIndicator(
                onRefresh: controller.load,
                child: ListView(
                  padding: const EdgeInsets.only(
                    bottom: AppSpacing.xl,
                  ),
                  children: [
                    if (order != null)
                      Padding(
                        padding: sidePadding,
                        child: ActiveOrderCard(
                          order: order,
                          totalSteps: totalSteps,
                          currentStep: currentStep,
                          onTap: () => Get.toNamed<void>(
                            AppRoutes.order,
                            arguments: order.id,
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    Padding(
                      padding: sidePadding,
                      child: PromoBanner(
                        onAction: () => Get.toNamed<void>(
                          AppRoutes.categories,
                        ),
                      ),
                    ),
                    if (controller.categories.isNotEmpty) ...[
                      sectionGap,
                      SectionHeader(
                        title: l10n.homeCategoriesTitle,
                        actionLabel: l10n.commonViewAll,
                        onAction: () => Get.toNamed<void>(
                          AppRoutes.categories,
                        ),
                      ),
                      headerGap,
                      Padding(
                        padding: sidePadding,
                        child: CategoryGrid(
                          categories: controller.categories
                              .take(
                            AppDefaults.homeCategoryLimit,
                          )
                              .toList(),
                          onTap: (category) =>
                              Get.toNamed<void>(
                                AppRoutes.products,
                                arguments: ProductsArgs(
                                  categoryIds: category.ids,
                                  title: category.name,
                                ),
                              ),
                        ),
                      ),
                    ],
                    if (controller.products.isNotEmpty) ...[
                      sectionGap,
                      SectionHeader(
                        title: l10n.homeMostOrdered,
                      ),
                      headerGap,
                      HorizontalStrip(
                        items: controller.products,
                        height: AppSizes.homeProductStrip,
                        itemBuilder: (product) =>
                            HomeProductCard(
                              product: product,
                              onTap: () => Get.toNamed<void>(
                                AppRoutes.product,
                                arguments: ProductArgs(
                                  product.id,
                                ),
                              ),
                              onAdd: () =>
                                  AddToCartFlow.quickAdd(
                                    context,
                                    product,
                                  ),
                            ),
                      ),
                    ],
                    ProviderSection(
                      title: l10n.homeStoresTitle,
                      kind: ProductKinds.product,
                      entries: controller.stores,
                    ),
                    ProviderSection(
                      title: l10n.homeCompaniesTitle,
                      kind: ProductKinds.service,
                      entries: controller.companies,
                    ),
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