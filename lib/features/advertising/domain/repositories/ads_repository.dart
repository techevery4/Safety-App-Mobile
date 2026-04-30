import '../entities/ad_entity.dart';

abstract class AdsRepository {
  Future<List<AdEntity>> getActiveAds();
  Future<void> createAd(AdEntity ad);
}
