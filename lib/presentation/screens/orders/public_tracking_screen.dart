import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/public_tracking_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/hex_color.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/label_value_row.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/code_chip.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_tone.dart';
import '../../widgets/orders/section_card.dart';

/// Tracking through a shared link (designs 16B, account 13).
class PublicTrackingScreen extends GetView<PublicTrackingController> {
  const PublicTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppTopBar(title: l10n.publicTrackingTitle),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppTextField(
            controller: controller.input,
            label: l10n.publicTrackingLabel,
            hint: l10n.publicTrackingHint,
            textDirection: TextDirection.ltr,
            prefixIcon: LucideIcons.link,
            onSubmitted: controller.open,
          ),
          PrimaryButton(
              label: l10n.publicTrackingOpen, onPressed: controller.open),
          const SizedBox(height: AppSpacing.lg),
          Obx(() {
            final data = controller.data.value;
            final failure = controller.failure.value;
            if (controller.isLoading.value) return const LoadingView();
            if (failure != null && data == null) {
              return ErrorBanner(failure: failure);
            }
            if (data == null) return const SizedBox.shrink();
            final order = data.order;
            final color = HexColor.tryParse(order.status.color) ??
                context.appColors.brand;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionCard(
                  title: data.project.name,
                  trailing: CodeChip(
                    label: order.status.label,
                    tone: order.status.isTerminal
                        ? StateTone.success
                        : StateTone.brand,
                  ),
                  children: [
                    LabelValueRow(
                      label: l10n.successOrderNumber,
                      value: order.code,
                      ltrValue: true,
                    ),
                    if (order.etaMinutes != null)
                      LabelValueRow(
                        label: l10n.publicTrackingEta,
                        value: l10n.trackingEta(order.etaMinutes!),
                      ),
                    if (data.driver != null)
                      LabelValueRow(
                        label: l10n.receiptDriver,
                        value: data.driver!.firstName,
                      ),
                    LabelValueRow(
                      label: l10n.publicTrackingUpdated,
                      value:
                          DateFormatter.dayMonthTime(order.updatedAt, locale),
                    ),
                  ],
                ),
                SectionCard(
                  title: l10n.orderTimelineTitle,
                  children: [
                    for (final entry in order.timeline)
                      LabelValueRow(
                        icon: LucideIcons.circleCheck,
                        label: entry.label,
                        value: DateFormatter.dayMonthTime(entry.at, locale),
                        valueStyle:
                            context.text.labelSmall?.copyWith(color: color),
                      ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
