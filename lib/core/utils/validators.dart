import '../constants/api_rules.dart';
import '../constants/app_defaults.dart';

enum FieldIssue { phoneInvalid, nameInvalid, otpIncomplete }

abstract final class Validators {
  static String normalizePhone(String input) {
    final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    final local = digits.startsWith('0') ? digits.substring(1) : digits;
    return '${AppDefaults.dialCode}$local';
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
