class SendOtpResult {
  const SendOtpResult({
    required this.phone,
    required this.expiresIn,
    required this.length,
  });

  final String phone;
  final int expiresIn;
  final int length;

  factory SendOtpResult.fromJson(Map<String, dynamic> json) => SendOtpResult(
        phone: json['phone'] as String,
        expiresIn: (json['expires_in'] as num).toInt(),
        length: (json['length'] as num).toInt(),
      );
}
