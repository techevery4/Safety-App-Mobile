import '../repositories/emergency_repository.dart';
import '../entities/emergency_event_entity.dart';
class TriggerEmergencyUseCase {
  final EmergencyRepository repository;
  TriggerEmergencyUseCase(this.repository);
  /// Alert must activate within 2 seconds of trigger
  Future<EmergencyEventEntity> call({required double lat, required double lng}) => repository.triggerEmergency(lat: lat, lng: lng);
}
