import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';
import '../common/network_thumb.dart';

/// Vendor logo, or the first letter of its name when there is none.
class ProviderLogo extends StatelessWidget {
  const ProviderLogo({super.key, required this.name, required this.url});

  final String name;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final trimmed = name.trim();
    final logo = url;
    return Container(
      width: AppSizes.providerLogo,
      height: AppSizes.providerLogo,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.brandSoft,
        borderRadius: AppRadius.mdAll,
      ),
      child: logo != null && logo.isNotEmpty
          ? NetworkThumb(url: logo, height: AppSizes.providerLogo)
          : Text(
              trimmed.isEmpty ? '' : trimmed.characters.first,
              style: context.text.headlineSmall?.copyWith(color: colors.brand),
            ),
    );
  }
}
