import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/order_actions_controller.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/checkout/label_value_row.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/code_chip.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/info_banner.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_tone.dart';
import '../../widgets/orders/section_card.dart';

/// Operator price offer: review, approve, reject (designs 09–11).
class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  final OrderActionsController controller = Get.find<OrderActionsController>();
  final TextEditingController _reason = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.loadOffer();
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _approve() async {
    final l10n = AppLocalizations.of(context);
    if (!await ConfirmationDialog.show(context, l10n.offerApproveConfirm)) {
      return;
    }
    if (await controller.approveOffer()) Get.back<void>();
  }

  Future<void> _reject() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(l10n.offerRejectConfirm),
        content: TextField(
          controller: _reason,
          decoration: InputDecoration(hintText: l10n.offerRejectReason),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialog).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialog).pop(true),
            child: Text(l10n.offerReject),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final why = _reason.text.trim();
    if (await controller.rejectOffer(why.isEmpty ? null : why)) {
      Get.back<void>();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final locale = Localizations.localeOf(context).languageCode;
    return Obx(() {
      final offer = controller.offer.value;
      final failure = controller.failure.value;
      if (offer == null) {
        return Scaffold(
          appBar: AppTopBar(title: l10n.offerView),
          body: failure != null
              ? ErrorView(failure: failure, onRetry: controller.loadOffer)
              : const LoadingView(),
        );
      }
      final open = offer.status == OfferStatus.sent;
      return Scaffold(
        appBar: AppTopBar(title: l10n.offerView),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            InfoBanner(
              icon: LucideIcons.receiptText,
              tone: open ? StateTone.warning : StateTone.brand,
              title: open ? l10n.offerPendingMessage : l10n.offerClosed,
            ),
            const SizedBox(height: AppSpacing.md),
            SectionCard(
              title: l10n.reviewProducts,
              trailing: CodeChip(label: offer.status, tone: StateTone.info),
              children: [
                for (final item in offer.items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: context.text.titleSmall?.copyWith(
                                  color: item.available ? null : colors.danger,
                                  decoration: item.available
                                      ? null
                                      : TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                '${item.qty} × ${item.unitPrice.formatted}',
                                style: context.text.labelSmall,
                              ),
                              if (!item.available)
                                Text(
                                  l10n.offerItemUnavailable,
                                  style: context.text.labelSmall
                                      ?.copyWith(color: colors.danger),
                                ),
                              if (item.substitute != null)
                                Text(
                                  l10n.offerSubstitute(
                                    item.substitute!.name,
                                    item.substitute!.unitPrice.formatted,
                                  ),
                                  style: context.text.labelSmall
                                      ?.copyWith(color: colors.brand),
                                ),
                              if (item.note != null)
                                Text(item.note!,
                                    style: context.text.labelSmall),
                            ],
                          ),
                        ),
                        Text(
                          item.lineTotal.formatted,
                          style: context.text.titleSmall,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SectionCard(
              children: [
                LabelValueRow(
                  label: l10n.quoteItemsTotal,
                  value: offer.itemsTotal.formatted,
                ),
                LabelValueRow(
                  label: l10n.quoteDeliveryFee,
                  value: offer.deliveryFee.formatted,
                ),
                const Divider(),
                LabelValueRow(
                  label: l10n.quoteTotal,
                  value: offer.total.formatted,
                  valueStyle:
                      context.text.titleLarge?.copyWith(color: colors.brand),
                ),
              ],
            ),
            if (offer.note != null) ...[
              InfoBanner(
                icon: LucideIcons.messageSquare,
                tone: StateTone.info,
                title: offer.note!,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (offer.expiresAt != null && open)
              InfoBanner(
                icon: LucideIcons.clock,
                tone: StateTone.warning,
                title: l10n.offerExpires(
                  DateFormatter.dayMonthTime(offer.expiresAt!, locale),
                ),
              ),
            if (failure != null) ...[
              const SizedBox(height: AppSpacing.md),
              ErrorBanner(failure: failure),
            ],
          ],
        ),
        bottomNavigationBar: open
            ? BottomActionBar(
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: l10n.offerApprove,
                        isLoading: controller.isBusy.value,
                        onPressed: _approve,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.danger,
                          side: BorderSide(color: colors.danger),
                        ),
                        onPressed: controller.isBusy.value ? null : _reject,
                        child: Text(l10n.offerReject),
                      ),
                    ),
                  ],
                ),
              )
            : null,
      );
    });
  }
}
