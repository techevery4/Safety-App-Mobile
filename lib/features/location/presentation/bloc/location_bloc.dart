import 'package:flutter_bloc/flutter_bloc.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<LocationLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(LocationLoadRequested event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    // TODO: implement
  }
}
