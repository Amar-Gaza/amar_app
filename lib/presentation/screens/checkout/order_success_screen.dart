import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/customer/shell_controller.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/checkout/label_value_row.dart';
import '../../widgets/common/link_button.dart';
import '../../widgets/common/primary_button.dart';

/// Order created (design 16).
class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  static const double _badge = 120;

  void _goTo(CustomerTab tab) {
    if (Get.isRegistered<ShellController>()) {
      Get.find<ShellController>().select(tab);
    }
    Get.until((route) => route.settings.name == AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as Order;
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goTo(CustomerTab.home);
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Container(
                  width: _badge,
                  height: _badge,
                  decoration: BoxDecoration(
                      color: colors.brand, shape: BoxShape.circle),
                  child: Icon(LucideIcons.check,
                      size: AppSizes.iconXl, color: colors.onBrand),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.successCaption,
                textAlign: TextAlign.center,
                style: context.text.labelSmall?.copyWith(color: colors.brand),
              ),
              Text(
                l10n.successTitle,
                textAlign: TextAlign.center,
                style: context.text.headlineMedium,
              ),
              Text(
                l10n.successMessage,
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
                    LabelValueRow(
                      label: l10n.successOrderNumber,
                      value: order.code,
                      ltrValue: true,
                    ),
                    LabelValueRow(
                      icon: LucideIcons.clock,
                      label: l10n.successStatus,
                      value: order.status.label,
                    ),
                    LabelValueRow(
                      icon: LucideIcons.banknote,
                      label: l10n.quoteTotal,
                      value: order.price.total.formatted,
                    ),
                    if (order.dropoff.label != null)
                      LabelValueRow(
                        icon: LucideIcons.truck,
                        label: l10n.successDeliverTo,
                        value: order.dropoff.label!,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: l10n.successTrack,
                onPressed: () => _goTo(CustomerTab.orders),
              ),
              Center(
                child: LinkButton(
                  label: l10n.successBackHome,
                  onPressed: () => _goTo(CustomerTab.home),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
