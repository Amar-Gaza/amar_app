import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/order_actions_controller.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/catalog/option_choice_tile.dart';
import '../../widgets/checkout/bottom_action_bar.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/info_banner.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_tone.dart';

/// Reason selection and confirmation (designs 07, 08).
class CancelOrderScreen extends StatefulWidget {
  const CancelOrderScreen({super.key});

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  final OrderActionsController controller = Get.find<OrderActionsController>();

  @override
  void initState() {
    super.initState();
    controller.loadReasons();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final ok = await ConfirmationDialog.show(context, l10n.cancelConfirm);
    if (!ok) return;
    final order = await controller.cancel();
    if (order != null) Get.back<void>();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppTopBar(title: l10n.cancelOrder),
      body: Obx(() {
        if (controller.reasons.isEmpty && controller.isBusy.value) {
          return const LoadingView();
        }
        final failure = controller.failure.value;
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            InfoBanner(
              icon: LucideIcons.circleAlert,
              tone: StateTone.warning,
              title: l10n.cancelHint,
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final reason in controller.reasons)
              OptionChoiceTile(
                label: reason.label,
                priceLabel: null,
                multi: false,
                selected: controller.reason.value == reason.key,
                onTap: () => controller.reason.value = reason.key,
              ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: controller.note,
              label: l10n.cancelNote,
              hint: l10n.detailsNoteHint,
              maxLength: AppDefaults.orderNoteMax,
            ),
            if (failure != null) ErrorBanner(failure: failure),
          ],
        );
      }),
      bottomNavigationBar: BottomActionBar(
        child: Obx(
          () => PrimaryButton(
            label: l10n.cancelSubmit,
            isLoading: controller.isBusy.value && controller.reasons.isNotEmpty,
            onPressed: controller.reason.value == null ? null : _submit,
          ),
        ),
      ),
    );
  }
}
