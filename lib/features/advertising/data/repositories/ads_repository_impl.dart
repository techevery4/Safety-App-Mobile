import '../../domain/repositories/ads_repository.dart';
import '../../domain/entities/ad_entity.dart';
class AdsRepositoryImpl implements AdsRepository {
  @override
  Future<List<AdEntity>> getActiveAds() async { return []; }
}
