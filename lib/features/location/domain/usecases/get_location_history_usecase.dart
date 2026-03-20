import '../repositories/location_repository.dart';
import '../entities/location_entity.dart';
class GetLocationHistoryUseCase {
  final LocationRepository repository;
  GetLocationHistoryUseCase(this.repository);
  Future<List<LocationEntity>> call() => repository.getLocationHistory();
}
