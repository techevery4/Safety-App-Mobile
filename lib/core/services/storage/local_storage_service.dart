/// Local storage service for non-sensitive preferences.
class LocalStorageService {
  /// Save a string value.
  Future<void> saveString(String key, String value) async {
    // TODO: implement using shared_preferences or hive
  }

  /// Get a string value.
  Future<String?> getString(String key) async {
    // TODO: implement
    return null;
  }

  /// Save a bool value.
  Future<void> saveBool(String key, bool value) async {
    // TODO: implement
  }

  /// Get a bool value.
  Future<bool?> getBool(String key) async {
    // TODO: implement
    return null;
  }

  /// Remove a value.
  Future<void> remove(String key) async {
    // TODO: implement
  }

  /// Clear all stored data.
  Future<void> clear() async {
    // TODO: implement
  }
}
