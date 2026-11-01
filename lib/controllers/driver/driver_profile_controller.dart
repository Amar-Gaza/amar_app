import 'package:get/get.dart';

import '../../core/localization/locale_controller.dart';
import '../../core/network/api_failure.dart';
import '../../data/services/driver/driver_profile_service.dart';
import '../../data/services/shared/upload_service.dart';
import '../../core/storage/secure_token_storage.dart';
import 'driver_session_controller.dart';

/// Language, vehicle and photo (designs 31, 32).
class DriverProfileController extends GetxController {
  DriverProfileController(
    this._profile,
    this._uploads,
    this._session,
    this._locale,
  );

  static const String avatarPurpose = 'avatar';

  final DriverProfileService _profile;
  final UploadService _uploads;
  final DriverSessionController _session;
  final LocaleController _locale;

  final RxString language = ''.obs;
  final RxString vehicle = ''.obs;
  final RxnString avatarPath = RxnString();
  final RxBool isSaving = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();

  @override
  void onInit() {
    super.onInit();
    final driver = _session.driver.value;
    language.value = driver?.locale ?? _locale.locale.value.languageCode;
    vehicle.value = driver?.vehicleType ?? '';
  }

  Future<bool> save() async {
    if (isSaving.value) return false;
    isSaving.value = true;
    failure.value = null;
    try {
      int? avatarId;
      final path = avatarPath.value;
      if (path != null) {
        avatarId = (await _uploads.upload(
          filePath: path,
          purpose: avatarPurpose,
          role: SessionRole.driver,
        ))
            .uploadId;
      }
      final updated = await _profile.update(
        locale: language.value,
        vehicleType: vehicle.value.isEmpty ? null : vehicle.value,
        avatarUploadId: avatarId,
      );
      _session.updateDriver(updated);
      await _locale.change(language.value);
      return true;
    } on ApiFailure catch (e) {
      failure.value = e;
      return false;
    } finally {
      isSaving.value = false;
    }
  }
}
