import '../masar/masar_models.dart';

class VerifyOtpResult {
  const VerifyOtpResult({
    required this.token,
    required this.tokenType,
    required this.isNewUser,
    required this.user,
  });

  final String token;
  final String tokenType;
  final bool isNewUser;
  final User user;

  factory VerifyOtpResult.fromJson(Map<String, dynamic> json) =>
      VerifyOtpResult(
        token: json['token'] as String,
        tokenType: json['token_type'] as String,
        isNewUser: json['is_new_user'] as bool,
        user: User.fromJson(Map<String, dynamic>.from(json['user'] as Map)),
      );
}
