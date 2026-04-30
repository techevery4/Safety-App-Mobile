import '../entities/ad_entity.dart';
import '../repositories/ads_repository.dart';

class CreateAdUseCase {
  final AdsRepository repository;

  CreateAdUseCase(this.repository);

  Future<void> call(AdEntity ad) async {
    return repository.createAd(ad);
  }
}
