/// Local data source for caching auth data.
abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> cacheToken(String token) async {
    // TODO: implement using secure storage
  }

  @override
  Future<String?> getCachedToken() async {
    // TODO: implement
    return null;
  }

  @override
  Future<void> clearCache() async {
    // TODO: implement
  }
}
