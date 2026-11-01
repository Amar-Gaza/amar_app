import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/shared/app_config_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/launcher.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/account/menu_tile.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/state_tone.dart';
import '../../widgets/common/status_illustration.dart';

/// Help entry points from the project config (account design 15).
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final config = Get.find<AppConfigController>().config.value;
    final phone = config?.project.supportPhone;
    final terms = config?.termsUrl;
    return Scaffold(
      appBar: AppTopBar(title: l10n.supportTitle),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Center(
            child: StatusIllustration(icon: LucideIcons.headset),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (phone != null && phone.isNotEmpty)
            MenuTile(
              icon: LucideIcons.phone,
              title: l10n.supportCall,
              subtitle: phone,
              onTap: () => Launcher.call(phone),
            ),
          MenuTile(
            icon: LucideIcons.packageSearch,
            title: l10n.supportOrderIssue,
            subtitle: l10n.supportOrderIssueHint,
            onTap: () => Get.until((r) => r.settings.name == AppRoutes.home),
          ),
          if (terms != null && terms.isNotEmpty)
            MenuTile(
              icon: LucideIcons.fileText,
              title: l10n.accountTerms,
              tone: StateTone.info,
              onTap: () => Launcher.web(terms),
            ),
        ],
      ),
    );
  }
}
