import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roamsafe/core/services/location/location_service.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService locationService;
  StreamSubscription? _positionSubscription;

  LocationBloc({required this.locationService}) : super(LocationInitial()) {
    on<LocationLoadRequested>(_onLoad);
    on<StartLocationTrackingEvent>(_onStartTracking);
    on<StopLocationTrackingEvent>(_onStopTracking);
    on<LocationUpdatedEvent>(_onLocationUpdated);
  }

  Future<void> _onLoad(LocationLoadRequested event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    final hasPermission = await locationService.requestPermission();
    if (!hasPermission) {
      emit(const LocationError('Location permission denied'));
      return;
    }
    final position = await locationService.getCurrentPosition();
    if (position != null) {
      emit(LocationLoaded(
        currentPosition: position,
        formattedCoordinates: LocationService.formatCoordinates(position),
        lastUpdated: DateTime.now(),
      ));
    } else {
      emit(const LocationLoaded(formattedCoordinates: 'Unable to get location'));
    }
  }

  Future<void> _onStartTracking(StartLocationTrackingEvent event, Emitter<LocationState> emit) async {
    final hasPermission = await locationService.requestPermission();
    if (!hasPermission) {
      emit(const LocationError('Location permission denied'));
      return;
    }

    // Get initial position first
    final position = await locationService.getCurrentPosition();
    if (position != null) {
      emit(LocationLoaded(
        currentPosition: position,
        formattedCoordinates: LocationService.formatCoordinates(position),
        isSharing: true,
        lastUpdated: DateTime.now(),
      ));
    } else {
      emit(const LocationLoaded(
        formattedCoordinates: 'Acquiring location...',
        isSharing: true,
      ));
    }

    // Start streaming updates
    locationService.startTracking();
    _positionSubscription?.cancel();
    _positionSubscription = locationService.positionStream.listen((pos) {
      add(LocationUpdatedEvent(pos));
    });
  }

  void _onStopTracking(StopLocationTrackingEvent event, Emitter<LocationState> emit) {
    locationService.stopTracking();
    _positionSubscription?.cancel();
    _positionSubscription = null;
    if (state is LocationLoaded) {
      emit((state as LocationLoaded).copyWith(isSharing: false));
    }
  }

  void _onLocationUpdated(LocationUpdatedEvent event, Emitter<LocationState> emit) {
    emit(LocationLoaded(
      currentPosition: event.position,
      formattedCoordinates: LocationService.formatCoordinates(event.position),
      isSharing: state is LocationLoaded ? (state as LocationLoaded).isSharing : true,
      lastUpdated: DateTime.now(),
    ));
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    locationService.stopTracking();
    return super.close();
  }
}
