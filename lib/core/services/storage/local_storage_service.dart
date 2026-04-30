import 'package:shared_preferences/shared_preferences.dart';

/// Local storage service for non-sensitive preferences.
class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  /// Save a string value.
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  /// Get a string value.
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  /// Save a bool value.
  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  /// Get a bool value.
  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  /// Remove a value.
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  /// Clear all stored data.
  Future<void> clear() async {
    await _prefs.clear();
  }
}
