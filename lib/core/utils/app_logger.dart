import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

abstract final class AppLogger {
  static final RegExp _secrets = RegExp(
    r'(pk_(test|live|preview)_[A-Za-z0-9]+|Bearer\s+[A-Za-z0-9._-]+)',
  );
  static const String _mask = '***';

  static void d(String message) {
    if (!kDebugMode) return;
    developer.log(message.replaceAll(_secrets, _mask), name: 'amar');
  }
}
