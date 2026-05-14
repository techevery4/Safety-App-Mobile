import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationState extends Equatable {
  const LocationState();
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final Position? currentPosition;
  final String formattedCoordinates;
  final bool isSharing;
  final DateTime? lastUpdated;

  const LocationLoaded({
    this.currentPosition,
    this.formattedCoordinates = 'Acquiring location...',
    this.isSharing = false,
    this.lastUpdated,
  });

  LocationLoaded copyWith({
    Position? currentPosition,
    String? formattedCoordinates,
    bool? isSharing,
    DateTime? lastUpdated,
  }) {
    return LocationLoaded(
      currentPosition: currentPosition ?? this.currentPosition,
      formattedCoordinates: formattedCoordinates ?? this.formattedCoordinates,
      isSharing: isSharing ?? this.isSharing,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [currentPosition, formattedCoordinates, isSharing, lastUpdated];
}

class LocationError extends LocationState {
  final String message;
  const LocationError(this.message);
  @override
  List<Object?> get props => [message];
}
