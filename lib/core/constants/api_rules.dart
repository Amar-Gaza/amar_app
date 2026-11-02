abstract final class ApiRules {
  static final RegExp phonePattern = RegExp(r'^\+?[0-9]{9,15}$');
  static final RegExp otpPattern = RegExp(r'^[0-9]{4}$');
  static const int nameMinLength = 2;
  static const int nameMaxLength = 120;
  static const int deviceNameMaxLength = 100;
  static const int otpLength = 4;
}
