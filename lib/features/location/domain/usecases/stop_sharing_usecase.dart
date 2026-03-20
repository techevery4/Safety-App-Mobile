import '../repositories/location_repository.dart';
class StopSharingUseCase {
  final LocationRepository repository;
  StopSharingUseCase(this.repository);
  Future<void> call() => repository.stopSharing();
}
