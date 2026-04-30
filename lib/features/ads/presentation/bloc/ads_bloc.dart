import 'package:flutter_bloc/flutter_bloc.dart';
import 'ads_event.dart';
import 'ads_state.dart';
import '../../../advertising/domain/usecases/get_active_ads_usecase.dart';
import '../../../advertising/domain/usecases/create_ad_usecase.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  final GetActiveAdsUseCase getActiveAdsUseCase;
  final CreateAdUseCase createAdUseCase;

  AdsBloc({
    required this.getActiveAdsUseCase,
    required this.createAdUseCase,
  }) : super(AdsInitial()) {
    on<AdsLoadRequested>(_onLoad);
    on<CreateAdEvent>(_onAddAd);
  }

  Future<void> _onLoad(AdsLoadRequested event, Emitter<AdsState> emit) async {
    emit(AdsLoading());
    try {
      final ads = await getActiveAdsUseCase();
      emit(AdsLoaded(ads));
    } catch (e) {
      emit(AdsError(e.toString()));
    }
  }

  Future<void> _onAddAd(CreateAdEvent event, Emitter<AdsState> emit) async {
    emit(AdsLoading());
    try {
      await createAdUseCase(event.ad);
      emit(AdCreatedSuccess());
      // Refresh list after creation
      add(AdsLoadRequested());
    } catch (e) {
      emit(AdsError(e.toString()));
    }
  }
}
