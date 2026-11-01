import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/constants/app_defaults.dart';
import '../../core/localization/locale_controller.dart';
import '../../core/network/api_failure.dart';
import '../../core/utils/validators.dart';
import '../../data/services/customer/profile_service.dart';
import '../../data/services/shared/upload_service.dart';
import '../shared/session_controller.dart';

/// Name, language and avatar (account designs 01, 02).
class EditProfileController extends GetxController {
  EditProfileController(
    this._profile,
    this._uploads,
    this._session,
    this._locale,
  );

  static const String avatarPurpose = 'avatar';

  final ProfileService _profile;
  final UploadService _uploads;
  final SessionController _session;
  final LocaleController _locale;

  final TextEditingController name = TextEditingController();
  final RxString language = AppDefaults.defaultLocale.obs;
  final RxnString avatarPath = RxnString();
  final RxBool isSaving = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  final Rxn<FieldIssue> nameIssue = Rxn<FieldIssue>();

  String? get avatarUrl => _session.user.value?.avatarUrl;

  @override
  void onInit() {
    super.onInit();
    name.text = _session.user.value?.name ?? '';
    language.value = _locale.locale.value.languageCode;
  }

  Future<bool> save() async {
    nameIssue.value = Validators.name(name.text);
    if (nameIssue.value != null || isSaving.value) return false;
    isSaving.value = true;
    failure.value = null;
    try {
      int? avatarId;
      final path = avatarPath.value;
      if (path != null) {
        avatarId = (await _uploads.upload(
          filePath: path,
          purpose: avatarPurpose,
        ))
            .uploadId;
      }
      final user = await _profile.update(
        name: name.text.trim(),
        locale: language.value,
        avatarUploadId: avatarId,
      );
      _session.updateUser(user);
      await _locale.change(language.value);
      return true;
    } on ApiFailure catch (e) {
      failure.value = e;
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    name.dispose();
    super.onClose();
  }
}
