import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/localization/price_label.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../common/network_thumb.dart';

/// Grid tile: image, name, short description, price and an add button.
class ProductGridCard extends StatelessWidget {
  const ProductGridCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAdd,
  });

  static const double _dimAlpha = 0.55;

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final available = product.inStock;
    return Material(
      color: context.scheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgAll,
        side: BorderSide(color: colors.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  NetworkThumb(url: product.imageUrl),
                  if (!available)
                    ColoredBox(
                      color: colors.onInk.withValues(alpha: _dimAlpha),
                      child: Center(
                        child: Text(
                          l10n.productUnavailable,
                          style: context.text.titleSmall,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleSmall,
                  ),
                  Text(
                    product.description ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.labelSmall
                        ?.copyWith(color: colors.mutedText),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          PriceLabel.of(product, l10n),
                          style: context.text.titleSmall
                              ?.copyWith(color: colors.brand),
                        ),
                      ),
                      SizedBox.square(
                        dimension: AppSizes.iconXl,
                        child: IconButton.filled(
                          padding: EdgeInsets.zero,
                          onPressed: available ? onAdd : null,
                          style: IconButton.styleFrom(
                            backgroundColor: colors.brand,
                            disabledBackgroundColor: colors.skeleton,
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadius.mdAll,
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
          ],
        ),
      ),
    );
  }
}
