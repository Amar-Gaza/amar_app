import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/driver/driver_session_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/auth/auth_intro.dart';
import '../../widgets/auth/language_toggle.dart';
import '../../widgets/auth/phone_field.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/brand_mark.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/link_button.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/screen_scaffold.dart';

/// Driver sign-in with phone and password (designs 01, 03).
class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final DriverSessionController _session = Get.find<DriverSessionController>();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_phone.text.isEmpty || _password.text.isEmpty) return;
    if (await _session.login(_phone.text, _password.text)) {
      await Get.offAllNamed<void>(AppRoutes.driverHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ScreenScaffold(
      appBar: const AppTopBar(
        showBack: false,
        leading: BrandMark(),
        trailing: LanguageToggle(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthIntro(
            icon: LucideIcons.truck,
            title: l10n.driverLoginTitle,
            subtitle: l10n.driverLoginSubtitle,
          ),
          PhoneField(
            controller: _phone,
            label: l10n.phoneLabel,
            hint: l10n.phoneHint,
            helper: l10n.phoneHelper,
            errorText: null,
            onSubmitted: _submit,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            controller: _password,
            label: l10n.driverPassword,
            hint: l10n.driverPasswordHint,
            prefix: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(_obscure ? LucideIcons.eye : LucideIcons.eyeOff),
            ),
            obscure: _obscure,
            onSubmitted: _submit,
          ),
          Obx(() {
            final failure = _session.failure.value;
            return failure == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: ErrorBanner(failure: failure),
                  );
          }),
          const SizedBox(height: AppSpacing.xl),
          Obx(
            () => PrimaryButton(
              label: l10n.driverLoginSubmit,
              isLoading: _session.isSubmitting.value,
              onPressed: _submit,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: LinkButton(
              label: l10n.driverIAmCustomer,
              // Pop back to the existing phone route when there is one:
              // re-pushing it with offAllNamed lets GetX dispose the old
              // AuthController after the new screen already grabbed it.
              onPressed: () => Navigator.of(context).canPop()
                  ? Get.back<void>()
                  : Get.offAllNamed<void>(AppRoutes.phone),
            ),
          ),
        ],
      ),
    );
  }
}
