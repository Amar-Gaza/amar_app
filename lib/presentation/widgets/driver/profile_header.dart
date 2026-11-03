import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../common/hero_circle.dart';

/// Green account banner with a rotated accent block, a white sheet that
/// overlaps it, and a round avatar on the seam.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.title,
    required this.name,
    required this.subtitle,
    this.imageUrl,
  });

  static const double _bannerHeight = 150;
  static const double _overlap = 50;
  static const double _avatar = 78;
  static const double _avatarBorder = 4;
  static const double _block = 150;
  static const double _blockAlpha = 0.22;
  static const double _circleAlpha = 0.07;
  static const double _sheetRadius = 40;
  static const double _blockAngle = 0.785;

  final String title;
  final String name;
  final String subtitle;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final url = imageUrl;
    final trimmed = name.trim();
    final bannerHeight = _bannerHeight + MediaQuery.paddingOf(context).top;
    final sheetTop = bannerHeight - _overlap;
    return Stack(
      children: [
        Container(
          height: bannerHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(gradient: colors.heroGradient),
          child: Stack(
            children: [
              const PositionedDirectional(
                top: -_block / 2,
                start: -_block / 3,
                child: HeroCircle(size: _block, alpha: _circleAlpha),
              ),
              PositionedDirectional(
                top: bannerHeight / 4,
                end: -_block / 2.4,
                child: Transform.rotate(
                  angle: _blockAngle,
                  child: Container(
                    width: _block,
                    height: _block,
                    decoration: BoxDecoration(
                      color: colors.accent.withValues(alpha: _blockAlpha),
                      borderRadius: AppRadius.illustrationAll,
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.lg),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      title,
                      style: context.text.titleLarge
                          ?.copyWith(color: colors.onBrand),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: sheetTop),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: _avatar / 2 + AppSpacing.sm,
              left: AppSpacing.page,
              right: AppSpacing.page,
            ),
            decoration: BoxDecoration(
              color: context.scheme.surface,
              borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(_sheetRadius),
              ),
            ),
            child: Column(
              children: [
                Text(name, style: context.text.headlineSmall),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: context.text.labelMedium
                      ?.copyWith(color: colors.mutedText),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: sheetTop - _avatar / 2,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: _avatar,
              height: _avatar,
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: colors.brandGradient,
                border: Border.all(
                  color: context.scheme.surface,
                  width: _avatarBorder,
                ),
                boxShadow: AppShadows.hero(colors),
              ),
              child: url != null && url.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      width: _avatar,
                      height: _avatar,
                    )
                  : Text(
                      trimmed.isEmpty ? '' : trimmed.characters.first,
                      style: context.text.headlineLarge?.copyWith(
                        color: colors.onBrand,
                        fontSize: AppSizes.iconLg,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
