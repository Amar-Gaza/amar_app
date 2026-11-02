import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/routes/route_args.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/catalog/provider_entry.dart';
import '../../../l10n/app_localizations.dart';
import '../common/section_header.dart';
import 'provider_card.dart';

/// Home section of stores or companies; hidden when it has no entries.
class ProviderSection extends StatelessWidget {
  const ProviderSection({
    super.key,
    required this.title,
    required this.kind,
    required this.entries,
  });

  final String title;
  final String kind;
  final List<ProviderEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(
            title: title,
            actionLabel: AppLocalizations.of(context).commonViewAll,
            onAction: () => Get.toNamed<void>(
              AppRoutes.providers,
              arguments: ProvidersArgs(kind: kind, title: title),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
            child: Column(
              children: [
                for (final entry in entries.take(AppDefaults.homeProviderLimit))
                  ProviderCard(
                    entry: entry,
                    onTap: () => Get.toNamed<void>(
                      AppRoutes.vendor,
                      arguments: entry.vendor.id,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
