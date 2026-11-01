import '../masar/masar_models.dart';

/// Data of POST /driver/auth/login.
class DriverLoginResult {
  const DriverLoginResult({
    required this.token,
    required this.tokenType,
    required this.driver,
  });

  factory DriverLoginResult.fromJson(Map<String, dynamic> json) =>
      DriverLoginResult(
        token: json['token'] as String,
        tokenType: json['token_type'] as String,
        driver:
            Driver.fromJson(Map<String, dynamic>.from(json['driver'] as Map)),
      );

  final String token;
  final String tokenType;
  final Driver driver;
}
