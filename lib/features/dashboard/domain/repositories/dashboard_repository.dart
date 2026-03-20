import '../entities/safety_status_entity.dart';
abstract class DashboardRepository {
  Future<SafetyStatusEntity> getSafetyStatus();
}
