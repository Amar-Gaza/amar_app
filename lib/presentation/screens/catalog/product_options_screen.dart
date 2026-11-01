import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/routes/route_args.dart';
import '../../../controllers/customer/product_controller.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/cart/cart_item.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/catalog/option_choice_tile.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/code_chip.dart';
import '../../widgets/common/network_thumb.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_tone.dart';

/// Option picker (design 10).
class ProductOptionsScreen extends StatelessWidget {
  const ProductOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as ProductArgs;
    final controller = Get.find<ProductController>(tag: args.tag);
    final product = controller.product.value!;
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Scaffold(
      appBar: AppTopBar(title: l10n.productOptionsScreenTitle),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: AppRadius.lgAll,
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: AppRadius.mdAll,
                  child: SizedBox.square(
                    dimension: AppSizes.iconTileLg,
                    child: NetworkThumb(url: product.imageUrl),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: context.text.titleMedium),
                      Text(
                        l10n.productBasePrice(product.price.formatted),
                        style: context.text.labelSmall
                            ?.copyWith(color: colors.mutedText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          for (final option in product.options) ...[
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(option.label, style: context.text.headlineSmall),
                      Text(
                        option.type == ProductOptionType.multi
                            ? l10n.optionMulti
                            : l10n.optionSingle,
                        style: context.text.labelSmall
                            ?.copyWith(color: colors.mutedText),
                      ),
                    ],
                  ),
                ),
                CodeChip(
                  label: option.required
                      ? l10n.optionRequired
                      : l10n.optionOptional,
                  tone: option.required ? StateTone.danger : StateTone.info,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Obx(
              () => Column(
                children: [
                  for (final choice in option.choices)
                    OptionChoiceTile(
                      label: choice.label,
                      priceLabel: choice.price.amount > 0
                          ? l10n.optionExtraPrice(choice.price.formatted)
                          : null,
                      multi: option.type == ProductOptionType.multi,
                      selected: controller.isSelected(option, choice),
                      onTap: () => controller.toggle(option, choice),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Obx(
            () => PrimaryButton(
              label: l10n.optionsContinue,
              onPressed: controller.missingRequired
                  ? null
                  : () => Get.toNamed<void>(
                        AppRoutes.productQuantity,
                        arguments: args,
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
