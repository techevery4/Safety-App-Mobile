import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Local data source for caching auth/user data.
abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;

  static const _cachedUserKey = 'cached_user';

  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheUser(UserModel user) async {
    await _prefs.setString(_cachedUserKey, user.toJsonString());
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = _prefs.getString(_cachedUserKey);
    if (jsonString == null) return null;
    return UserModel.fromJsonString(jsonString);
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_cachedUserKey);
  }
}
