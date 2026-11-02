import 'package:flutter/material.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import 'directional_icons.dart';
import 'square_icon_button.dart';

/// Centered title with a square back button at the start.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.title,
    this.showBack,
    this.onBack,
    this.leading,
    this.trailing,
  });

  final String? title;

  /// Defaults to whether the route can be popped.
  final bool? showBack;
  final VoidCallback? onBack;
  final Widget? leading;
  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.topBarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = showBack ?? Navigator.of(context).canPop();
    final start = leading ??
        (canPop
            ? SquareIconButton(
                icon: DirectionalIcons.back(context),
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              )
            : null);
    return Material(
      color: context.scheme.surface,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: AppSizes.topBarHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                    style: context.text.headlineSmall,
                  ),
                ),
              if (start != null)
                Align(
                    alignment: AlignmentDirectional.centerStart, child: start),
              if (trailing != null)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: trailing,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
