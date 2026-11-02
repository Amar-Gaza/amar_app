import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/customer/order_details_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../checkout/label_value_row.dart';
import '../common/confirmation_dialog.dart';
import '../common/error_banner.dart';
import '../common/primary_button.dart';
import 'section_card.dart';

/// The vendor's price for a service, waiting for the customer's answer.
class ServiceQuoteCard extends StatelessWidget {
  const ServiceQuoteCard({
    super.key,
    required this.quote,
    required this.controller,
  });

  final ServiceQuote quote;
  final OrderDetailsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final visitAt = quote.visitAt;
    final locale = Localizations.localeOf(context).languageCode;
    return SectionCard(
      title: l10n.serviceQuoteTitle,
      children: [
        LabelValueRow(
          label: l10n.serviceQuoteLabor,
          value: quote.amount.formatted,
        ),
        LabelValueRow(
          label: l10n.serviceQuoteTotal,
          value: quote.total.formatted,
        ),
        if (visitAt != null)
          LabelValueRow(
            label: l10n.serviceQuoteVisit,
            value: DateFormatter.dayMonthTime(visitAt, locale),
          ),
        if (quote.note != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(quote.note!, style: context.text.bodySmall),
        ],
        Obx(() {
          final failure = controller.quoteFailure.value;
          if (failure == null) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: ErrorBanner(failure: failure),
          );
        }),
        const SizedBox(height: AppSpacing.md),
        Obx(
          () => PrimaryButton(
            label: l10n.serviceQuoteAccept,
            isLoading: controller.isAnsweringQuote.value,
            onPressed: controller.acceptQuote,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton(
          onPressed: () async {
            final confirmed = await ConfirmationDialog.show(
              context,
              l10n.serviceQuoteRejectConfirm,
            );
            if (confirmed) await controller.rejectQuote();
          },
          child: Text(l10n.serviceQuoteReject),
        ),
      ],
    );
  }
}
