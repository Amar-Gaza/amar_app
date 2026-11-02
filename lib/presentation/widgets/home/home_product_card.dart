import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/localization/price_label.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/network_thumb.dart';
import '../common/press_scale.dart';

/// Compact product tile for the horizontal home strip.
class HomeProductCard extends StatelessWidget {
  const HomeProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAdd,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return PressScale(
      onTap: onTap,
      child: Container(
        width: AppSizes.homeProductCard,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: context.scheme.surface,
          borderRadius: AppRadius.cardAll,
          border: Border.all(color: colors.border),
          boxShadow: AppShadows.card(colors),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: AppRadius.mdAll,
              child: NetworkThumb(
                url: product.imageUrl,
                height: AppSizes.homeProductImage,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.text.titleSmall,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    PriceLabel.of(product, AppLocalizations.of(context)),
                    style:
                        context.text.titleMedium?.copyWith(color: colors.brand),
                  ),
                ),
                if (product.inStock)
                  SizedBox.square(
                    dimension: AppSizes.addButton,
                    child: IconButton.filled(
                      padding: EdgeInsets.zero,
                      onPressed: onAdd,
                      style: IconButton.styleFrom(
                        backgroundColor: colors.brand,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.smAll,
                        ),
                      ),
                      icon: Icon(
                        LucideIcons.plus,
                        size: AppSizes.iconSm,
                        color: colors.onBrand,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
