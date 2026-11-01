import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/customer/vendors_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/catalog/vendor_list_card.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/empty_view.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/skeleton_list.dart';

/// Vendor listing (design 05).
class VendorsScreen extends GetView<VendorsController> {
  const VendorsScreen({super.key});

  static const double _loadMoreExtent = 300;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppTopBar(title: l10n.vendorsTitle),
      body: Obx(() {
        final failure = controller.failure.value;
        if (controller.isLoading.value) {
          return const SkeletonList(showSearch: false);
        }
        if (failure != null) {
          return ErrorView(failure: failure, onRetry: controller.load);
        }
        if (controller.items.isEmpty) {
          return EmptyView(icon: LucideIcons.store, title: l10n.vendorsEmpty);
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scroll) {
              if (scroll.metrics.extentAfter < _loadMoreExtent) {
                controller.loadMore();
              }
              return false;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: controller.items.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, index) {
                final vendor = controller.items[index];
                return VendorListCard(
                  vendor: vendor,
                  onTap: () => Get.toNamed<void>(
                    AppRoutes.vendor,
                    arguments: vendor.id,
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
