import 'package:flutter_bloc/flutter_bloc.dart';
import 'contacts_event.dart';
import 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc() : super(ContactsInitial()) {
    on<ContactsLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(ContactsLoadRequested event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());
    // TODO: implement
  }
}
