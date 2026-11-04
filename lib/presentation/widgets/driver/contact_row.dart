import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/launcher.dart';
import '../../../l10n/app_localizations.dart';
import '../common/square_icon_button.dart';

/// Person on a job (customer or store) with message and call shortcuts.
class ContactRow extends StatelessWidget {
  const ContactRow({
    super.key,
    required this.name,
    required this.subtitle,
    this.phone,
    this.imageUrl,
    this.canMessage = true,
  });

  final String name;
  final String subtitle;
  final String? phone;
  final String? imageUrl;
  final bool canMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final trimmed = name.trim();
    final url = imageUrl;
    final number = phone;
    return Row(
      children: [
        Container(
          width: AppSizes.iconTileSm,
          height: AppSizes.iconTileSm,
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.brandSoft,
            borderRadius: AppRadius.mdAll,
          ),
          child: url != null && url.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  width: AppSizes.iconTileSm,
                  height: AppSizes.iconTileSm,
                )
              : Text(
                  trimmed.isEmpty ? '' : trimmed.characters.first,
                  style:
                      context.text.headlineSmall?.copyWith(color: colors.brand),
                ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.titleMedium,
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    context.text.labelSmall?.copyWith(color: colors.mutedText),
              ),
            ],
          ),
        ),
        if (number != null && number.isNotEmpty) ...[
          if (canMessage) ...[
            SquareIconButton(
              icon: LucideIcons.messageCircle,
              tone: SquareIconTone.mint,
              tooltip: l10n.driverMessage,
              onPressed: () => Launcher.sms(number),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          SquareIconButton(
            icon: LucideIcons.phone,
            tone: SquareIconTone.brand,
            tooltip: l10n.driverCall,
            onPressed: () => Launcher.call(number),
          ),
        ],
      ],
    );
  }
}
