import 'package:equatable/equatable.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();
  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {}
class ContactsLoading extends ContactsState {}
class ContactsLoaded extends ContactsState {}
class ContactsError extends ContactsState {
  final String message;
  const ContactsError(this.message);
  @override
  List<Object?> get props => [message];
}
