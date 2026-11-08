import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/routes/route_args.dart';
import '../../../controllers/customer/catalog_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/empty_view.dart';
import '../../widgets/home/provider_card.dart';

class ProvidersScreen extends GetView<CatalogController> {
  const ProvidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as ProvidersArgs;

    return Scaffold(
      appBar: AppTopBar(title: args.title),
      body: Obx(() {
        final query = args.query?.trim().toLowerCase() ?? '';

        final entries = controller
            .providers(args.kind)
            .where(
              (entry) =>
                  query.isEmpty ||
                  entry.vendor.name.toLowerCase().contains(query),
            )
            .toList();

        if (entries.isEmpty) {
          return EmptyView(
            icon: LucideIcons.store,
            title: AppLocalizations.of(context).homeProvidersEmpty,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(
            AppSpacing.page,
          ),
          itemCount: entries.length,
          itemBuilder: (_, index) => ProviderCard(
            entry: entries[index],
            onTap: () => Get.toNamed<void>(
              AppRoutes.vendor,
              arguments: entries[index].vendor.id,
            ),
          ),
        );
      }),
    );
  }
}
