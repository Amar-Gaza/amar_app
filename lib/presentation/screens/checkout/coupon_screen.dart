import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/checkout_controller.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/localization/error_message_resolver.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/checkout/label_value_row.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/code_chip.dart';
import '../../widgets/common/field_label.dart';
import '../../widgets/common/info_banner.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_tone.dart';
import '../../widgets/common/status_illustration.dart';

/// Coupon entry and result (designs 10, 11A, 11B).
class CouponScreen extends GetView<CheckoutController> {
  const CouponScreen({super.key});

  static const double _heroHeight = 140;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppTopBar(title: l10n.couponTitle),
      body: Obx(() {
        final check = controller.couponCheck.value;
        final failure = controller.couponFailure.value;
        if (check != null) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              const Center(
                child: StatusIllustration(
                  icon: LucideIcons.check,
                  tone: StateTone.success,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                  child: CodeChip(label: check.code, tone: StateTone.success)),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.couponValidTitle,
                textAlign: TextAlign.center,
                style: context.text.headlineMedium,
              ),
              Text(
                check.description ?? l10n.couponValidMessage,
                textAlign: TextAlign.center,
                style: context.text.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.lgAll,
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  children: [
                    if (check.percent != null)
                      LabelValueRow(
                        label: l10n.couponValue,
                        value: '${check.percent}%',
                      )
                    else if (check.amount != null)
                      LabelValueRow(
                        label: l10n.couponValue,
                        value: check.amount!.formatted,
                      ),
                    if (check.maxDiscount != null)
                      LabelValueRow(
                        label: l10n.couponMaxDiscount,
                        value: check.maxDiscount!.formatted,
                      ),
                    LabelValueRow(
                      label: l10n.couponMinTotal,
                      value: check.minTotal.formatted,
                    ),
                    LabelValueRow(
                      label: l10n.couponUsesLeft,
                      value: '${check.usesLeftForYou}',
                    ),
                    if (check.expiresAt != null)
                      LabelValueRow(
                        label: l10n.couponExpires,
                        value: DateFormatter.dayMonthTime(
                          check.expiresAt!,
                          locale,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              height: _heroHeight,
              decoration: BoxDecoration(
                color: colors.ink,
                borderRadius: AppRadius.lgAll,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.ticket,
                      size: AppSizes.iconLg, color: colors.accent),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.couponHero,
                    style:
                        context.text.titleMedium?.copyWith(color: colors.onInk),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FieldLabel(l10n.couponCodeLabel),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.couponInput,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: AppDefaults.couponMax,
                    textDirection: TextDirection.ltr,
                    onSubmitted: (_) => controller.checkCoupon(),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: l10n.couponCodeHint,
                      errorText: failure == null ? null : '',
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  height: AppSizes.fieldHeight,
                  child: FilledButton(
                    style: FilledButton.styleFrom(minimumSize: Size.zero),
                    onPressed: controller.isCheckingCoupon.value
                        ? null
                        : controller.checkCoupon,
                    child: controller.isCheckingCoupon.value
                        ? const SizedBox.square(
                            dimension: AppSizes.iconSm,
                            child: CircularProgressIndicator(
                              strokeWidth: AppSizes.loaderStroke,
                            ),
                          )
                        : Text(l10n.couponCheck),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (failure != null)
              InfoBanner(
                title: l10n.couponInvalidTitle,
                message: ErrorMessageResolver.resolve(failure, l10n),
              )
            else
              InfoBanner(
                icon: LucideIcons.info,
                tone: StateTone.brand,
                title: l10n.couponCheckNote,
              ),
            if (controller.coupon.value != null) ...[
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: controller.removeCoupon,
                icon: const Icon(LucideIcons.x),
                label: Text(l10n.couponRemove(controller.coupon.value!)),
              ),
            ],
          ],
        );
      }),
      bottomNavigationBar: BottomActionBar(
        child: Obx(
          () => PrimaryButton(
            label: l10n.couponApply,
            onPressed: controller.couponCheck.value == null
                ? null
                : () {
                    controller.applyCoupon();
                    Get.back<void>();
                  },
          ),
        ),
      ),
    );
  }
}
