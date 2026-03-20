import '../entities/location_entity.dart';
abstract class LocationRepository {
  Future<void> shareLocation({required double lat, required double lng});
  Future<void> stopSharing();
  Future<List<LocationEntity>> getLocationHistory();
}
