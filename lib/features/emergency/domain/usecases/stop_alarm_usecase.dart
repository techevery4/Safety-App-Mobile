import '../repositories/emergency_repository.dart';
class StopAlarmUseCase {
  final EmergencyRepository repository;
  StopAlarmUseCase(this.repository);
  /// Stop alarm is only accessible to the user who triggered it
  Future<void> call() => repository.stopAlarm();
}
