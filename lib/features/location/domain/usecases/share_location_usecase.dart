import '../repositories/location_repository.dart';
class ShareLocationUseCase {
  final LocationRepository repository;
  ShareLocationUseCase(this.repository);
  Future<void> call({required double lat, required double lng}) => repository.shareLocation(lat: lat, lng: lng);
}
