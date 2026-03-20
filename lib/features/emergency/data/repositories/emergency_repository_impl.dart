import '../../domain/repositories/emergency_repository.dart';
import '../../domain/entities/emergency_event_entity.dart';
class EmergencyRepositoryImpl implements EmergencyRepository {
  @override
  Future<EmergencyEventEntity> triggerEmergency({required double lat, required double lng}) async { throw UnimplementedError(); }
  @override
  Future<void> cancelEmergency({required String id}) async { throw UnimplementedError(); }
  @override
  Future<void> stopAlarm() async { throw UnimplementedError(); }
}
