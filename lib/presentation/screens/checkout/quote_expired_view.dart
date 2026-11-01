import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/checkout_controller.dart';
import '../../../core/constants/api_query.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/common/state_tone.dart';
import '../../widgets/common/state_view.dart';

/// Quote expired or already used: ask for a fresh one (design 13).
class QuoteExpiredView extends GetView<CheckoutController> {
  const QuoteExpiredView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Obx(() {
      final used =
          controller.placeFailure.value?.code == ApiErrorCodes.quoteUsed;
      return StateView(
        icon: LucideIcons.clock,
        tone: StateTone.warning,
        code: used ? ApiErrorCodes.quoteUsed : ApiErrorCodes.quoteExpired,
        title: used ? l10n.quoteUsedTitle : l10n.quoteExpiredTitle,
        message: l10n.quoteExpiredMessage,
        primaryLabel: l10n.quoteRefresh,
        isPrimaryLoading: controller.isQuoting.value,
        onPrimary: controller.refreshQuote,
        secondaryLabel: l10n.quoteBackToCart,
        onSecondary: () => Get.back<void>(),
      );
    });
  }
}
