import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/driver/driver_session_controller.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/auth/auth_body_text.dart';
import '../../widgets/auth/auth_heading.dart';
import '../../widgets/auth/phone_field.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/directional_icons.dart';
import '../../widgets/common/error_banner.dart';
import '../../widgets/common/link_button.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/screen_scaffold.dart';
import '../../widgets/common/square_icon_button.dart';

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
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _phone.addListener(_refresh);
    _password.addListener(_refresh);
  }

  void _refresh() {
    final ok = _phone.text.length >= AppDefaults.driverPhoneMinDigits &&
        _password.text.length >= AppDefaults.driverPasswordMin;
    if (ok != _canSubmit) setState(() => _canSubmit = ok);
  }

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

  // Pop back to the existing phone route when there is one: re-pushing it with
  // offAllNamed lets GetX dispose the old AuthController after the new screen
  // already grabbed it.
  void _toCustomer() => Navigator.of(context).canPop()
      ? Get.back<void>()
      : Get.offAllNamed<void>(AppRoutes.phone);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return ScreenScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: SquareIconButton(
              icon: DirectionalIcons.back(context),
              onPressed: _toCustomer,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              width: AppSizes.driverTile,
              height: AppSizes.driverTile,
              decoration: BoxDecoration(
                gradient: colors.brandGradient,
                borderRadius: AppRadius.xlAll,
                boxShadow: AppShadows.hero(colors),
              ),
              child: Icon(
                LucideIcons.truck,
                size: AppSizes.iconXl,
                color: colors.onBrand,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AuthHeading(
            title: l10n.driverDesignTitle,
            subtitle: AuthBodyText(l10n.driverDesignSubtitle),
          ),
          const SizedBox(height: AppSpacing.page),
          PhoneField(
            controller: _phone,
            label: l10n.phoneLabel,
            hint: l10n.phoneHint,
            onSubmitted: _submit,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            controller: _password,
            label: l10n.driverPassword,
            hint: l10n.driverDesignPasswordHint,
            prefixIcon: LucideIcons.lock,
            textDirection: TextDirection.ltr,
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            suffix: IconButton(
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
          const SizedBox(height: AppSpacing.md),
          Obx(
            () => PrimaryButton(
              label: l10n.driverLoginSubmit,
              isLoading: _session.isSubmitting.value,
              onPressed: _canSubmit ? _submit : null,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: LinkButton(
              label: l10n.driverDesignCustomer,
              onPressed: _toCustomer,
            ),
          ),
        ],
      ),
    );
  }
}
