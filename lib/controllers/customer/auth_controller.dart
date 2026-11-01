import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../core/constants/api_query.dart';
import '../../core/constants/api_rules.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/constants/app_durations.dart';
import '../../core/network/api_failure.dart';
import '../../core/utils/validators.dart';
import '../../data/services/customer/auth_service.dart';
import '../shared/session_controller.dart';

class AuthController extends GetxController {
  AuthController(this._auth, this._session);

  final AuthService _auth;
  final SessionController _session;

  final TextEditingController phoneInput = TextEditingController();
  final TextEditingController otpInput = TextEditingController();
  final RxString otpCode = ''.obs;
  final RxInt otpLength = ApiRules.defaultOtpLength.obs;
  final RxInt secondsLeft = 0.obs;
  final RxBool isSubmitting = false.obs;
  final RxString fullPhone = ''.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  final Rxn<FieldIssue> phoneIssue = Rxn<FieldIssue>();
  final Rxn<FieldIssue> otpIssue = Rxn<FieldIssue>();
  Timer? _timer;

  bool get isOtpInvalid => failure.value?.code == ApiErrorCodes.otpInvalid;
  bool get isOtpExpired => failure.value?.code == ApiErrorCodes.otpExpired;
  bool get canResend => secondsLeft.value <= 0;
  bool get isVerifying =>
      isSubmitting.value && otpCode.value.length == otpLength.value;

  Future<void> sendOtp() async {
    if (isSubmitting.value) return;
    phoneIssue.value = Validators.phone(phoneInput.text);
    if (phoneIssue.value != null) return;
    final sent = await _requestCode(Validators.normalizePhone(phoneInput.text));
    if (sent) await Get.toNamed<void>(AppRoutes.otp);
  }

  Future<void> resendOtp() async {
    if (isSubmitting.value || !canResend) return;
    await _requestCode(fullPhone.value);
  }

  Future<bool> _requestCode(String phone) async {
    isSubmitting.value = true;
    failure.value = null;
    otpCode.value = '';
    otpInput.clear();
    try {
      final result = await _auth.sendOtp(phone);
      fullPhone.value = result.phone;
      otpLength.value = result.length;
      _startCountdown(result.expiresIn);
      return true;
    } on ApiFailure catch (e) {
      failure.value = e;
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  void setCode(String input) {
    if (isSubmitting.value) return;
    final digits = input.replaceAll(RegExp('[^0-9]'), '');
    final code = digits.length > otpLength.value
        ? digits.substring(0, otpLength.value)
        : digits;
    failure.value = null;
    otpIssue.value = null;
    otpCode.value = code;
    if (code.length == otpLength.value) verify();
  }

  /// Clears a rejected code so the user can type it again.
  void retryOtp() {
    failure.value = null;
    otpIssue.value = null;
    otpCode.value = '';
    otpInput.clear();
  }

  Future<void> verify() async {
    if (isSubmitting.value) return;
    otpIssue.value = Validators.otp(otpCode.value);
    if (otpIssue.value != null) return;
    isSubmitting.value = true;
    failure.value = null;
    try {
      final result = await _auth.verifyOtp(
        phone: fullPhone.value,
        code: otpCode.value,
        deviceName: AppDefaults.deviceName,
      );
      await _session.start(result.token, result.user);
      await Get.offAllNamed<void>(
        result.isNewUser ? AppRoutes.profile : AppRoutes.home,
      );
    } on ApiFailure catch (e) {
      // The rejected code stays visible until the user retries or edits it.
      failure.value = e;
    } finally {
      isSubmitting.value = false;
    }
  }

  void _startCountdown(int seconds) {
    _timer?.cancel();
    secondsLeft.value = seconds;
    _timer = Timer.periodic(AppDurations.tick, (timer) {
      if (secondsLeft.value <= 1) {
        secondsLeft.value = 0;
        timer.cancel();
      } else {
        secondsLeft.value -= 1;
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    phoneInput.dispose();
    otpInput.dispose();
    super.onClose();
  }
}
