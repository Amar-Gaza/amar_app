import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/customer/order_details_controller.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../checkout/label_value_row.dart';
import '../common/error_banner.dart';
import '../common/info_banner.dart';
import '../common/primary_button.dart';
import '../common/state_tone.dart';
import 'section_card.dart';

/// Account to pay into and the receipt upload for a bank transfer order.
class TransferReceiptCard extends StatelessWidget {
  const TransferReceiptCard({
    super.key,
    required this.payment,
    required this.controller,
  });

  final OrderPayment payment;
  final OrderDetailsController controller;

  Future<void> _pick() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: AppDefaults.imageQuality,
    );
    if (file != null) await controller.sendReceipt(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final gateway = payment.gateway;
    return SectionCard(
      title: l10n.transferTitle,
      children: [
        Text(l10n.transferHint, style: context.text.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        if (gateway != null) ...[
          LabelValueRow(label: l10n.transferBank, value: gateway.name),
          if (gateway.holder != null)
            LabelValueRow(label: l10n.transferHolder, value: gateway.holder!),
          if (gateway.accountNumber != null)
            LabelValueRow(
              label: l10n.transferAccount,
              value: gateway.accountNumber!,
            ),
        ],
        if (payment.reviewNote != null) ...[
          const SizedBox(height: AppSpacing.sm),
          InfoBanner(
            tone: StateTone.warning,
            title: l10n.transferFixNeeded,
            message: payment.reviewNote,
          ),
        ],
        Obx(() {
          final failure = controller.receiptFailure.value;
          if (failure == null) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: ErrorBanner(failure: failure),
          );
        }),
        const SizedBox(height: AppSpacing.md),
        Obx(
          () => PrimaryButton(
            label: l10n.transferUpload,
            isLoading: controller.isSendingReceipt.value,
            onPressed: _pick,
          ),
        ),
      ],
    );
  }
}
