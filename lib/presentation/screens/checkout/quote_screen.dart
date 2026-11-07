import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/customer/checkout_controller.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/duration_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/checkout/checkout_steps.dart';
import '../../widgets/checkout/label_value_row.dart';
import '../../widgets/checkout/price_card.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/info_banner.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_tone.dart';
import 'quote_expired_view.dart';

/// Server quote with its expiry countdown (designs 12 and 13).
class QuoteScreen extends GetView<CheckoutController> {
  const QuoteScreen({super.key});

  static const int _distanceDigits = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Obx(() {
      final quote = controller.quote.value;
      if (quote == null || controller.isQuoteExpired) {
        return Scaffold(
          appBar: AppTopBar(title: l10n.quoteTitle),
          body: const QuoteExpiredView(),
        );
      }
      return Scaffold(
        appBar: AppTopBar(title: l10n.quoteTitle),
        body: Column(
          children: [
            const CheckoutSteps(current: 2),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  InfoBanner(
                    icon: LucideIcons.clock,
                    tone: StateTone.warning,
                    title: l10n.quoteValidFor(
                      DurationFormatter.clock(
                          controller.quoteSecondsLeft.value),
                    ),
                    message: controller.isService
                        ? l10n.quoteServiceHint
                        : l10n.quoteValidHint,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PriceCard(
                    quote: quote,
                    secondsLeft: controller.quoteSecondsLeft.value,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: colors.surfaceSoft,
                      borderRadius: AppRadius.lgAll,
                    ),
                    child: LabelValueRow(
                      label: l10n.quoteDistance,
                      value: l10n.vendorDistance(
                        quote.distanceKm.toStringAsFixed(_distanceDigits),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomActionBar(
          child: PrimaryButton(
            label: l10n.quoteReview,
            onPressed: () => Get.toNamed<void>(AppRoutes.checkoutReview),
          ),
        ),
      );
    });
  }
}
