import '../../domain/entities/emergency_event_entity.dart';
class EmergencyEventModel extends EmergencyEventEntity {
  const EmergencyEventModel({required super.id, required super.triggeredAt, required super.latitude, required super.longitude, super.isActive});
  factory EmergencyEventModel.fromJson(Map<String, dynamic> json) {
    return EmergencyEventModel(id: json['id'], triggeredAt: DateTime.parse(json['triggeredAt']), latitude: json['latitude'], longitude: json['longitude'], isActive: json['isActive'] ?? true);
  }
}
