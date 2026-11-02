import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/masar/masar_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/auth/auth_body_text.dart';
import '../../../widgets/auth/auth_heading.dart';
import '../../../widgets/auth/map_preview.dart';
import '../../../widgets/common/link_button.dart';
import '../../../widgets/common/primary_button.dart';
import '../../../widgets/common/screen_scaffold.dart';

/// Asks for the first address after signup, or a new one from home.
class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  // Opened from home it pops back: re-creating the home route would dispose
  // controllers still in use below it.
  void _leave(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Get.back<void>();
    } else {
      Get.offAllNamed<void>(AppRoutes.home);
    }
  }

  Future<void> _addAddress(BuildContext context) async {
    final address = await Get.toNamed<Address>(AppRoutes.checkoutAddressNew);
    if (address != null && context.mounted) _leave(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ScreenScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthHeading(
            title: l10n.locationTitle,
            subtitle: AuthBodyText(l10n.locationSubtitle),
          ),
          const SizedBox(height: AppSpacing.sm),
          const MapPreview(),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: l10n.locationUseCurrent,
            onPressed: () => _addAddress(context),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: LinkButton(
              label: l10n.commonSkip,
              onPressed: () => _leave(context),
            ),
          ),
        ],
      ),
    );
  }
}
