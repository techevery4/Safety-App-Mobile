import '../repositories/dashboard_repository.dart';
import '../entities/safety_status_entity.dart';
class GetSafetyStatusUseCase {
  final DashboardRepository repository;
  GetSafetyStatusUseCase(this.repository);
  Future<SafetyStatusEntity> call() => repository.getSafetyStatus();
}
