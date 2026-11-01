import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/order_actions_controller.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/primary_button.dart';

/// Stars and a comment for the driver and the store (design 15).
class RateOrderScreen extends GetView<OrderActionsController> {
  const RateOrderScreen({super.key});

  Widget _stars(BuildContext context, RxInt value) => Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 1; i <= AppDefaults.maxStars; i++)
              IconButton(
                iconSize: AppSizes.iconLg,
                onPressed: () => value.value = i,
                icon: Icon(
                  LucideIcons.star,
                  color: i <= value.value
                      ? context.appColors.warning
                      : context.appColors.subtleText,
                ),
              ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppTopBar(title: l10n.rateTitle),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            l10n.rateDriver,
            textAlign: TextAlign.center,
            style: context.text.headlineSmall,
          ),
          _stars(context, controller.stars),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.rateStore,
            textAlign: TextAlign.center,
            style: context.text.titleMedium,
          ),
          _stars(context, controller.vendorStars),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: controller.comment,
            label: l10n.rateComment,
            hint: l10n.rateCommentHint,
            maxLength: AppDefaults.rateCommentMax,
          ),
          Obx(() {
            final failure = controller.failure.value;
            return failure == null
                ? const SizedBox.shrink()
                : ErrorBanner(failure: failure);
          }),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: Obx(
          () => PrimaryButton(
            label: l10n.rateSubmit,
            isLoading: controller.isBusy.value,
            onPressed: controller.stars.value == 0
                ? null
                : () async {
                    if (await controller.rate(hasVendor: true)) {
                      Get.back<void>();
                    }
                  },
          ),
        ),
      ),
    );
  }
}
