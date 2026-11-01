import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/order_actions_controller.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/state_view.dart';

/// Create, copy and revoke a public tracking link (design 16).
class ShareLinkScreen extends GetView<OrderActionsController> {
  const ShareLinkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppTopBar(title: l10n.shareTitle),
      body: Obx(() {
        final link = controller.shareLink.value;
        final failure = controller.failure.value;
        if (link == null) {
          return StateView(
            icon: LucideIcons.share2,
            title: l10n.shareIntroTitle,
            message: l10n.shareIntroMessage,
            primaryLabel: l10n.shareCreate,
            isPrimaryLoading: controller.isBusy.value,
            onPrimary: controller.createShareLink,
            footer: failure == null ? null : ErrorBanner(failure: failure),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colors.surfaceSoft,
                borderRadius: AppRadius.lgAll,
              ),
              child: SelectableText(
                link.url,
                textDirection: TextDirection.ltr,
                style: context.text.titleSmall,
              ),
            ),
            if (link.expiresAt != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.shareExpires(
                  DateFormatter.dayMonthTime(link.expiresAt!, locale),
                ),
                style: context.text.labelSmall,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: l10n.shareCopy,
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: link.url));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.shareCopied)),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.danger,
                side: BorderSide(color: colors.danger),
              ),
              onPressed:
                  controller.isBusy.value ? null : controller.revokeShareLink,
              child: Text(l10n.shareRevoke),
            ),
            if (failure != null) ...[
              const SizedBox(height: AppSpacing.md),
              ErrorBanner(failure: failure),
            ],
          ],
        );
      }),
    );
  }
}
