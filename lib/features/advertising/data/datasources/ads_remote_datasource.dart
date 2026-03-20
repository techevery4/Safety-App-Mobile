abstract class AdsRemoteDataSource {
  Future<List<Map<String, dynamic>>> getActiveAds();
}
class AdsRemoteDataSourceImpl implements AdsRemoteDataSource {
  @override
  Future<List<Map<String, dynamic>>> getActiveAds() async { return []; }
}
