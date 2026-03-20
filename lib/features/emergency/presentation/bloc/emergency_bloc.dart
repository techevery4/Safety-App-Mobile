import 'package:flutter_bloc/flutter_bloc.dart';
import 'emergency_event.dart';
import 'emergency_state.dart';

class EmergencyBloc extends Bloc<EmergencyEvent, EmergencyState> {
  EmergencyBloc() : super(EmergencyInitial()) {
    on<EmergencyLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(EmergencyLoadRequested event, Emitter<EmergencyState> emit) async {
    emit(EmergencyLoading());
    // TODO: implement
  }
}
