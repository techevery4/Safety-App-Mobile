import 'package:equatable/equatable.dart';

abstract class AdsEvent extends Equatable {
  const AdsEvent();
  @override
  List<Object?> get props => [];
}

class AdsLoadRequested extends AdsEvent {}
