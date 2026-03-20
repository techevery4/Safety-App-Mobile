import '../entities/emergency_event_entity.dart';
abstract class EmergencyRepository {
  Future<EmergencyEventEntity> triggerEmergency({required double lat, required double lng});
  Future<void> cancelEmergency({required String id});
  Future<void> stopAlarm();
}
