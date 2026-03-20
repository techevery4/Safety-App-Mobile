import 'package:equatable/equatable.dart';

abstract class EmergencyState extends Equatable {
  const EmergencyState();
  @override
  List<Object?> get props => [];
}

class EmergencyInitial extends EmergencyState {}
class EmergencyLoading extends EmergencyState {}
class EmergencyLoaded extends EmergencyState {}
class EmergencyError extends EmergencyState {
  final String message;
  const EmergencyError(this.message);
  @override
  List<Object?> get props => [message];
}
