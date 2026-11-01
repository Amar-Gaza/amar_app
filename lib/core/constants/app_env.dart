import 'package:flutter/foundation.dart';

abstract final class AppEnv {
  static const String projectKey = String.fromEnvironment('AMAR_PROJECT_KEY');
  static const String devMember = String.fromEnvironment('AMAR_DEV_MEMBER');
  static const String appVersion =
      String.fromEnvironment('AMAR_APP_VERSION', defaultValue: '1.0.0');
  static const String baseUrl = 'https://masar.toldpath.com/api';

  static bool get isConfigured => projectKey.isNotEmpty;
  static bool get sendsDevMember => kDebugMode && devMember.isNotEmpty;
}
