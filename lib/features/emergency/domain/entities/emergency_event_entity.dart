import 'package:equatable/equatable.dart';
class EmergencyEventEntity extends Equatable {
  final String id;
  final DateTime triggeredAt;
  final double latitude;
  final double longitude;
  final bool isActive;
  const EmergencyEventEntity({required this.id, required this.triggeredAt, required this.latitude, required this.longitude, this.isActive = true});
  @override
  List<Object?> get props => [id, triggeredAt, latitude, longitude, isActive];
}
