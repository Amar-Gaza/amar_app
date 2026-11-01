import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/routes/route_args.dart';
import '../../../controllers/customer/categories_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/catalog/catalog_search_field.dart';
import '../../widgets/catalog/category_row.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/empty_view.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/skeleton_list.dart';
import '../../widgets/common/state_tone.dart';

/// All categories (design 04).
class CategoriesScreen extends GetView<CategoriesController> {
  const CategoriesScreen({super.key});

  static const List<StateTone> _tones = [
    StateTone.brand,
    StateTone.danger,
    StateTone.warning,
    StateTone.info,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppTopBar(title: l10n.categoriesTitle),
      body: Column(
        children: [
          CatalogSearchField(
            hint: l10n.categoriesSearchHint,
            onChanged: (value) => controller.filter.value = value,
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
              final items = controller.visible;
              if (items.isEmpty) {
                return EmptyView(
                  icon: LucideIcons.layoutGrid,
                  title: l10n.categoriesEmpty,
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (_, index) {
                  final category = items[index];
                  return CategoryRow(
                    category: category,
                    tone: _tones[index % _tones.length],
                    onTap: () => Get.toNamed<void>(
                      AppRoutes.products,
                      arguments: ProductsArgs(
                        categoryId: category.id,
                        title: category.name.trim(),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
