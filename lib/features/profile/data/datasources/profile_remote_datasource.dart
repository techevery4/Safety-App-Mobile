abstract class ProfileRemoteDataSource {
  Future<Map<String, dynamic>> getProfile();
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data);
}
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getProfile() async { throw UnimplementedError(); }
  @override
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async { throw UnimplementedError(); }
}
