import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/localization/locale_controller.dart';
import '../../core/network/api_failure.dart';
import '../../core/utils/validators.dart';
import '../../data/services/customer/profile_service.dart';
import '../../data/services/shared/upload_service.dart';
import '../shared/session_controller.dart';

class ProfileSetupController extends GetxController {
  ProfileSetupController(
    this._profile,
    this._uploads,
    this._session,
    this._locale,
  );

  static const String nameField = 'name';
  static const String avatarPurpose = 'avatar';

  final ProfileService _profile;
  final UploadService _uploads;
  final SessionController _session;
  final LocaleController _locale;

  final TextEditingController nameInput = TextEditingController();
  final TextEditingController phoneInput = TextEditingController();
  final RxString nameText = ''.obs;
  final RxnString avatarPath = RxnString();
  final RxBool isSubmitting = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  final Rxn<FieldIssue> nameIssue = Rxn<FieldIssue>();

  @override
  void onInit() {
    super.onInit();
    nameInput.addListener(_onNameChanged);
    final user = _session.user.value;
    nameInput.text = user?.name ?? '';
    phoneInput.text =
        (user?.phone ?? '').replaceFirst(AppDefaults.dialCode, '');
  }

  void _onNameChanged() => nameText.value = nameInput.text;

  Future<void> submit() async {
    if (isSubmitting.value) return;
    nameIssue.value = Validators.name(nameInput.text);
    if (nameIssue.value != null) return;
    isSubmitting.value = true;
    failure.value = null;
    try {
      final path = avatarPath.value;
      final avatarId = path == null
          ? null
          : (await _uploads.upload(filePath: path, purpose: avatarPurpose))
              .uploadId;
      final user = await _profile.update(
        name: nameInput.text.trim(),
        locale: _locale.locale.value.languageCode,
        avatarUploadId: avatarId,
      );
      _session.updateUser(user);
      await _next();
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// The name stays editable later from the account screen.
  Future<void> skip() async {
    if (!isSubmitting.value) await _next();
  }

  Future<void> _next() async {
    await Get.offAllNamed<void>(AppRoutes.location);
  }

  @override
  void onClose() {
    nameInput
      ..removeListener(_onNameChanged)
      ..dispose();
    phoneInput.dispose();
    super.onClose();
  }
}
