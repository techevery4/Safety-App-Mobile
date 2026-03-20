abstract class LocationRemoteDataSource {
  Future<void> shareLocation({required double lat, required double lng});
  Future<void> stopSharing();
  Future<List<Map<String, dynamic>>> getLocationHistory();
}
class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  @override
  Future<void> shareLocation({required double lat, required double lng}) async {}
  @override
  Future<void> stopSharing() async {}
  @override
  Future<List<Map<String, dynamic>>> getLocationHistory() async { return []; }
}
