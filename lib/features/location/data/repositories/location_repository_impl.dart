import '../../domain/repositories/location_repository.dart';
import '../../domain/entities/location_entity.dart';
class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<void> shareLocation({required double lat, required double lng}) async {}
  @override
  Future<void> stopSharing() async {}
  @override
  Future<List<LocationEntity>> getLocationHistory() async { return []; }
}
