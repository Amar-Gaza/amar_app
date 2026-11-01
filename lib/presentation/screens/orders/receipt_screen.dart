import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/customer/order_actions_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/label_value_row.dart';
import '../../widgets/checkout/payment_label.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/orders/section_card.dart';

/// Order receipt (design 14).
class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final OrderActionsController controller = Get.find<OrderActionsController>();

  @override
  void initState() {
    super.initState();
    controller.loadReceipt();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final ar = locale == 'ar';
    return Scaffold(
      appBar: AppTopBar(title: l10n.receiptTitle),
      body: Obx(() {
        final receipt = controller.receipt.value;
        final failure = controller.failure.value;
        if (receipt == null) {
          return failure != null
              ? ErrorView(failure: failure, onRetry: controller.loadReceipt)
              : const LoadingView();
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              ar ? receipt.project.ar : receipt.project.en,
              textAlign: TextAlign.center,
              style: context.text.headlineSmall,
            ),
            Text(
              receipt.code,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: context.text.titleMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            SectionCard(
              children: [
                LabelValueRow(
                  label: l10n.successStatus,
                  value: ar ? receipt.status.ar : receipt.status.en,
                ),
                LabelValueRow(
                  label: l10n.receiptDate,
                  value: DateFormatter.dayMonthTime(receipt.createdAt, locale),
                ),
                if (receipt.driver != null)
                  LabelValueRow(
                    label: l10n.receiptDriver,
                    value: receipt.driver!,
                  ),
                LabelValueRow(
                  label: l10n.checkoutPayment,
                  value: paymentLabel(l10n, receipt.payment.method),
                ),
              ],
            ),
            SectionCard(
              title: l10n.reviewProducts,
              children: [
                for (final item in receipt.items)
                  LabelValueRow(label: item.name, value: '× ${item.qty}'),
              ],
            ),
            SectionCard(
              children: [
                for (final line in receipt.lines)
                  LabelValueRow(
                    label: ar ? line.label.ar : line.label.en,
                    value: line.amount.formatted,
                  ),
                const Divider(),
                LabelValueRow(
                  label: l10n.quoteTotal,
                  value: receipt.total.formatted,
                  valueStyle: context.text.titleLarge
                      ?.copyWith(color: context.appColors.brand),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
