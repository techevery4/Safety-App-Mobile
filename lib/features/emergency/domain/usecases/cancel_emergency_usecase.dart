import '../repositories/emergency_repository.dart';
class CancelEmergencyUseCase {
  final EmergencyRepository repository;
  CancelEmergencyUseCase(this.repository);
  Future<void> call({required String id}) => repository.cancelEmergency(id: id);
}
