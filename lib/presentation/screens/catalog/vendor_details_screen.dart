import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/routes/route_args.dart';
import '../../../controllers/customer/vendor_details_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/catalog/add_to_cart_flow.dart';
import '../../widgets/catalog/availability_banner.dart';
import '../../widgets/catalog/opening_hours_card.dart';
import '../../widgets/catalog/product_grid.dart';
import '../../widgets/catalog/vendor_header.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/common/segment_item.dart';
import '../../widgets/common/segmented_tabs.dart';

/// Vendor page: header, then products and/or services, hours and about.
class VendorDetailsScreen extends GetView<VendorDetailsController> {
  const VendorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Obx(() {
        final vendor = controller.vendor.value;
        final failure = controller.vendorFailure.value;
        if (vendor == null && failure != null) {
          return SafeArea(
            child: ErrorView(failure: failure, onRetry: controller.reload),
          );
        }
        if (vendor == null) return const LoadingView();
        final tabs = [
          if (controller.hasProducts.value || !controller.hasServices.value)
            SegmentItem(
              value: VendorTab.products,
              label: l10n.vendorTabProducts,
            ),
          if (controller.hasServices.value)
            SegmentItem(
              value: VendorTab.services,
              label: l10n.vendorTabServices,
            ),
          SegmentItem(value: VendorTab.hours, label: l10n.vendorTabHours),
          SegmentItem(value: VendorTab.about, label: l10n.vendorTabAbout),
        ];
        final header = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VendorHeader(vendor: vendor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SegmentedTabs<VendorTab>(
                items: tabs,
                selected: controller.tab.value,
                onSelect: controller.selectTab,
              ),
            ),
          ],
        );
        return switch (controller.tab.value) {
          VendorTab.products || VendorTab.services => ProductGrid(
              header: header,
              products: controller.items.toList(),
              isLoadingMore: controller.isLoadingMore.value,
              onEndReached: controller.loadMore,
              onOpen: (p) => Get.toNamed<void>(
                AppRoutes.product,
                arguments: ProductArgs(p.id),
              ),
              onAdd: (p) => AddToCartFlow.quickAdd(context, p),
            ),
          VendorTab.hours => ListView(
              children: [
                header,
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      AvailabilityBanner(vendor: vendor),
                      const SizedBox(height: AppSpacing.md),
                      OpeningHoursCard(hours: vendor.openingHours),
                    ],
                  ),
                ),
              ],
            ),
          VendorTab.about => ListView(
              children: [
                header,
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    vendor.description ?? l10n.vendorNoDescription,
                    style: context.text.bodyMedium,
                  ),
                ),
              ],
            ),
        };
      }),
    );
  }
}
