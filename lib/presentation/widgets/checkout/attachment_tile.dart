import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/customer/checkout_controller.dart';
import '../../../core/localization/error_message_resolver.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../common/icon_tile.dart';
import '../common/state_tone.dart';

/// Upload row: progress (09A), done, or failed with retry (09B).
class AttachmentTile extends StatelessWidget {
  const AttachmentTile({
    super.key,
    required this.item,
    required this.onRetry,
    required this.onRemove,
  });

  final PendingUpload item;
  final VoidCallback onRetry;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Obx(() {
      final failure = item.failure.value;
      final done = item.isDone;
      final tone = failure != null
          ? StateTone.danger
          : done
              ? StateTone.success
              : StateTone.brand;
      return Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: AppRadius.lgAll,
          border: Border.all(
            color: failure != null ? colors.danger : colors.border,
          ),
        ),
        child: Row(
          children: [
            IconTile(
              icon: failure != null
                  ? LucideIcons.circleAlert
                  : done
                      ? LucideIcons.check
                      : LucideIcons.upload,
              size: AppSizes.iconTileSm,
              iconSize: AppSizes.iconSm,
              background: tone.background(colors),
              foreground: tone.foreground(colors),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (failure != null)
                    Text(
                      ErrorMessageResolver.resolve(failure, l10n),
                      style: context.text.labelSmall
                          ?.copyWith(color: colors.danger),
                    )
                  else if (done)
                    Text(
                      l10n.uploadDone,
                      style: context.text.labelSmall
                          ?.copyWith(color: colors.success),
                    )
                  else
                    ClipRRect(
                      borderRadius: AppRadius.pillAll,
                      child: LinearProgressIndicator(
                        value: item.progress.value,
                        minHeight: AppSizes.progressHeight,
                      ),
                    ),
                ],
              ),
            ),
            if (failure != null)
              IconButton(
                tooltip: l10n.commonRetry,
                onPressed: onRetry,
                icon: Icon(LucideIcons.refreshCw, color: colors.brand),
              ),
            IconButton(
              tooltip: l10n.cartRemove,
              onPressed: onRemove,
              icon: Icon(LucideIcons.x, color: colors.mutedText),
            ),
          ],
        ),
      );
    });
  }
}
