import 'package:equatable/equatable.dart';
class SafetyStatusEntity extends Equatable {
  final bool isSafe;
  final String? activeEmergencyId;
  const SafetyStatusEntity({required this.isSafe, this.activeEmergencyId});
  @override
  List<Object?> get props => [isSafe, activeEmergencyId];
}
