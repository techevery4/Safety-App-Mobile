import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for sensitive data (tokens, etc).
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Write a secure value.
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a secure value.
  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  /// Delete a secure value.
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  /// Delete all secure values.
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
