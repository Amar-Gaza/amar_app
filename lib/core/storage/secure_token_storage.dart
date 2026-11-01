import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';

enum SessionRole { customer, driver }

class SecureTokenStorage {
  SecureTokenStorage()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        );

  final FlutterSecureStorage _storage;

  String _key(SessionRole role) => role == SessionRole.driver
      ? StorageKeys.driverToken
      : StorageKeys.customerToken;

  Future<String?> read(SessionRole role) => _storage.read(key: _key(role));

  Future<void> write(SessionRole role, String token) =>
      _storage.write(key: _key(role), value: token);

  Future<void> clear(SessionRole role) => _storage.delete(key: _key(role));
}
