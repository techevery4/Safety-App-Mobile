import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();
  @override
  List<Object?> get props => [];
}

class LocationLoadRequested extends LocationEvent {}

class StartLocationTrackingEvent extends LocationEvent {}

class StopLocationTrackingEvent extends LocationEvent {}

class LocationUpdatedEvent extends LocationEvent {
  final Position position;
  const LocationUpdatedEvent(this.position);
  @override
  List<Object?> get props => [position];
}
