import '../constants/api_rules.dart';
import '../constants/app_defaults.dart';

enum FieldIssue { phoneInvalid, nameInvalid, otpIncomplete }

abstract final class Validators {
  static String normalizePhone(String input) {
    final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    final local = digits.startsWith('0') ? digits.substring(1) : digits;
    return '${AppDefaults.dialCode}$local';
  }

  /// National form with the leading zero (0599100001). Driver accounts are
  /// stored this way, and login compares the phone exactly.
  static String localPhone(String input) {
    final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    final code = AppDefaults.dialCode.replaceAll(RegExp(r'[^0-9]'), '');
    final national =
        digits.startsWith(code) ? digits.substring(code.length) : digits;
    return national.startsWith('0') ? national : '0$national';
  }

  static FieldIssue? phone(String input) =>
      ApiRules.phonePattern.hasMatch(normalizePhone(input))
          ? null
          : FieldIssue.phoneInvalid;

  static FieldIssue? name(String input) {
    final value = input.trim();
    final ok = value.length >= ApiRules.nameMinLength &&
        value.length <= ApiRules.nameMaxLength;
    return ok ? null : FieldIssue.nameInvalid;
  }

  static FieldIssue? otp(String input) =>
      ApiRules.otpPattern.hasMatch(input) ? null : FieldIssue.otpIncomplete;
}
