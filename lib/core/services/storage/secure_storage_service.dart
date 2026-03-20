/// Secure storage service for sensitive data (tokens, etc).
class SecureStorageService {
  /// Write a secure value.
  Future<void> write({required String key, required String value}) async {
    // TODO: implement using flutter_secure_storage
  }

  /// Read a secure value.
  Future<String?> read({required String key}) async {
    // TODO: implement
    return null;
  }

  /// Delete a secure value.
  Future<void> delete({required String key}) async {
    // TODO: implement
  }

  /// Delete all secure values.
  Future<void> deleteAll() async {
    // TODO: implement
  }
}
