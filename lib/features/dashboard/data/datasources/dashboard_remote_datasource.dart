abstract class DashboardRemoteDataSource {
  Future<Map<String, dynamic>> getSafetyStatus();
}
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getSafetyStatus() async { throw UnimplementedError(); }
}
