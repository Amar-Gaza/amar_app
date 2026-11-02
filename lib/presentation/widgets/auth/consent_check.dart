import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';

/// Terms agreement checkbox. The links are display-only for now.
class ConsentCheck extends StatelessWidget {
  const ConsentCheck({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final base = context.text.bodySmall;
    final link = base?.copyWith(
      color: colors.brandBright,
      fontWeight: FontWeight.w700,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (checked) => onChanged(checked ?? false),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: base,
                children: [
                  TextSpan(text: l10n.consentAgree),
                  TextSpan(text: l10n.consentTerms, style: link),
                  TextSpan(text: l10n.consentAnd),
                  TextSpan(text: l10n.consentPrivacy, style: link),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
