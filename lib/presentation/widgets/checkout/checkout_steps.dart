import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';

/// Cart → delivery → quote → confirm progress strip.
class CheckoutSteps extends StatelessWidget {
  const CheckoutSteps({super.key, required this.current});

  static const double _dot = 28;

  /// Zero-based index of the active step.
  final int current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final labels = [
      l10n.checkoutStepCart,
      l10n.checkoutStepDelivery,
      l10n.checkoutStepQuote,
      l10n.checkoutStepConfirm,
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: _dot,
                    height: _dot,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < current ? colors.brand : colors.brandSoft,
                      border: Border.all(
                        color: i <= current ? colors.brand : colors.border,
                      ),
                    ),
                    child: i < current
                        ? Icon(
                            LucideIcons.check,
                            size: AppSizes.iconXs,
                            color: colors.onBrand,
                          )
                        : Text(
                            '${i + 1}',
                            style: context.text.labelSmall?.copyWith(
                              color: i == current
                                  ? colors.brand
                                  : colors.subtleText,
                            ),
                          ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    labels[i],
                    style: context.text.labelSmall?.copyWith(
                      color: i <= current ? colors.ink : colors.subtleText,
                      fontWeight:
                          i == current ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
