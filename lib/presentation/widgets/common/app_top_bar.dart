import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'brand_mark.dart';
import 'directional_icons.dart';

/// Centered title, back arrow at the start and the brand mark at the end.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.title,
    this.showBack,
    this.onBack,
    this.leading,
    this.trailing,
    this.showBrand = true,
  });

  final String? title;

  /// Defaults to whether the route can be popped.
  final bool? showBack;
  final VoidCallback? onBack;
  final Widget? leading;
  final Widget? trailing;
  final bool showBrand;

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.topBarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = showBack ?? Navigator.of(context).canPop();
    final start = leading ??
        (canPop
            ? IconButton(
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                icon: Icon(DirectionalIcons.back(context)),
              )
            : null);
    final end = trailing ?? (showBrand ? const BrandMark() : null);
    return Material(
      color: context.scheme.surface,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: AppSizes.topBarHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: context.appColors.border),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.topBarHeight,
                  ),
                  child: Text(
                    title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleMedium,
                  ),
                ),
              if (start != null)
                Align(
                    alignment: AlignmentDirectional.centerStart, child: start),
              if (end != null)
                Align(alignment: AlignmentDirectional.centerEnd, child: end),
            ],
          ),
        ),
      ),
    );
  }
}
