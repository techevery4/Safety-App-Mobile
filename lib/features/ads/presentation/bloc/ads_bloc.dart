import 'package:flutter_bloc/flutter_bloc.dart';
import 'ads_event.dart';
import 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  AdsBloc() : super(AdsInitial()) {
    on<AdsLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(AdsLoadRequested event, Emitter<AdsState> emit) async {
    emit(AdsLoading());
    // TODO: implement
  }
}
