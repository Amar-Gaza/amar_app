import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../core/localization/locale_controller.dart';
import '../../core/network/api_failure.dart';
import '../../core/utils/validators.dart';
import '../../data/services/customer/profile_service.dart';
import '../shared/session_controller.dart';

class ProfileSetupController extends GetxController {
  ProfileSetupController(this._profile, this._session, this._locale);

  static const String nameField = 'name';

  final ProfileService _profile;
  final SessionController _session;
  final LocaleController _locale;

  final TextEditingController nameInput = TextEditingController();
  final RxBool isSubmitting = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  final Rxn<FieldIssue> nameIssue = Rxn<FieldIssue>();
  final RxInt nameLength = 0.obs;

  Rx<Locale> get locale => _locale.locale;

  @override
  void onInit() {
    super.onInit();
    nameInput.addListener(_onNameChanged);
  }

  void _onNameChanged() => nameLength.value = nameInput.text.length;

  Future<void> changeLanguage(String languageCode) =>
      _locale.change(languageCode);

  Future<void> submit() async {
    if (isSubmitting.value) return;
    nameIssue.value = Validators.name(nameInput.text);
    if (nameIssue.value != null) return;
    isSubmitting.value = true;
    failure.value = null;
    try {
      final user = await _profile.update(
        name: nameInput.text.trim(),
        locale: _locale.locale.value.languageCode,
      );
      _session.updateUser(user);
      await Get.offAllNamed<void>(AppRoutes.home);
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    nameInput
      ..removeListener(_onNameChanged)
      ..dispose();
    super.onClose();
  }
}
