import '../repositories/ads_repository.dart';
import '../entities/ad_entity.dart';
class GetActiveAdsUseCase {
  final AdsRepository repository;
  GetActiveAdsUseCase(this.repository);
  Future<List<AdEntity>> call() => repository.getActiveAds();
}
