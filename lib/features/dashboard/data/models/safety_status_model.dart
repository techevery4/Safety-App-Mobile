import '../../domain/entities/safety_status_entity.dart';
class SafetyStatusModel extends SafetyStatusEntity {
  const SafetyStatusModel({required super.isSafe, super.activeEmergencyId});
  factory SafetyStatusModel.fromJson(Map<String, dynamic> json) {
    return SafetyStatusModel(isSafe: json['isSafe'] ?? true, activeEmergencyId: json['activeEmergencyId']);
  }
}
