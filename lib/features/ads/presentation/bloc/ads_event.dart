import 'package:equatable/equatable.dart';
import '../../../advertising/domain/entities/ad_entity.dart';

abstract class AdsEvent extends Equatable {
  const AdsEvent();
  @override
  List<Object?> get props => [];
}

class AdsLoadRequested extends AdsEvent {}

class CreateAdEvent extends AdsEvent {
  final AdEntity ad;
  const CreateAdEvent(this.ad);
  @override
  List<Object?> get props => [ad];
}
