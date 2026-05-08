import '../../domain/repositories/ads_repository.dart';
import '../../domain/entities/ad_entity.dart';

class AdsRepositoryImpl implements AdsRepository {
  final List<AdEntity> _ads = [
    // Dummy ads
    const AdEntity(
      id: '1',
      imageUrl: '://via.placeholder.com/1080x1920?text=Safety+First',
      title: 'Safety First',
      status: 'active',
    ),
    const AdEntity(
      id: '2',
      imageUrl: 'https://via.placeholder.com/1080x1920?text=Emergency+Response',
      title: 'Emergency Response',
      status: 'active',
    ),
  ];

  @override
  Future<List<AdEntity>> getActiveAds() async {
    // Return all ads marked as active
    return _ads
        .where((ad) => ad.status == 'active' || ad.status == null)
        .toList();
  }

  @override
  Future<void> createAd(AdEntity ad) async {
    // In-memory storage: add to the list
    // In a real app, this would be an API call
    _ads.add(ad);
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
  }
}
