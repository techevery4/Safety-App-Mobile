import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/usecases/get_confirmed_contacts_usecase.dart';
import '../../domain/usecases/get_pending_contacts_usecase.dart';
import '../../domain/usecases/add_contact_usecase.dart';
import '../../domain/usecases/remove_contact_usecase.dart';
import '../../domain/usecases/respond_to_contact_request_usecase.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import 'contacts_event.dart';
import 'contacts_state.dart';

/// BLoC for the contacts feature.
class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final GetConfirmedContactsUseCase _getConfirmedContactsUseCase;
  final GetPendingContactsUseCase _getPendingContactsUseCase;
  final AddContactUsecase _addContactUseCase;
  final RemoveContactUsecase _removeContactUseCase;
  final RespondToContactRequestUseCase _respondToContactRequestUseCase;
  final AuthRepository _authRepository;

  List<ContactEntity> _confirmed = [];
  List<ContactEntity> _pending = [];
  int _currentPage = 0;
  bool _hasNext = false;
  static const int _pageSize = 25;

  ContactsBloc({
    required GetConfirmedContactsUseCase getConfirmedContactsUseCase,
    required GetPendingContactsUseCase getPendingContactsUseCase,
    required AddContactUsecase addContactUseCase,
    required RemoveContactUsecase removeContactUseCase,
    required RespondToContactRequestUseCase respondToContactRequestUseCase,
    required AuthRepository authRepository,
  })  : _getConfirmedContactsUseCase = getConfirmedContactsUseCase,
        _getPendingContactsUseCase = getPendingContactsUseCase,
        _addContactUseCase = addContactUseCase,
        _removeContactUseCase = removeContactUseCase,
        _respondToContactRequestUseCase = respondToContactRequestUseCase,
        _authRepository = authRepository,
        super(ContactsInitial()) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<LoadMoreConfirmedContactsEvent>(_onLoadMoreConfirmed);
    on<AddContactEvent>(_onAddContact);
    on<RemoveContactEvent>(_onRemoveContact);
    on<AcceptContactEvent>(_onAcceptContact);
    on<DeclineContactEvent>(_onDeclineContact);
    on<SearchContactsEvent>(_onSearchContacts);
  }

  Future<void> _onLoadContacts(
    LoadContactsEvent event,
    Emitter<ContactsState> emit,
  ) async {
    emit(ContactsLoading());
    try {
      final user = await _authRepository.getCurrentUser();
      if (user == null) {
        emit(const ContactsError(message: 'User not authenticated'));
        return;
      }

      _currentPage = 0;
      final results = await Future.wait([
        _getPendingContactsUseCase(user.id),
        _getConfirmedContactsUseCase(user.id, pageNo: _currentPage, pageSize: _pageSize),
      ]);

      _pending = results[0] as List<ContactEntity>;
      final paginatedConfirmed = results[1] as dynamic; // PaginatedContacts

      _confirmed = paginatedConfirmed.content;
      _hasNext = paginatedConfirmed.hasNext;

      emit(ContactsLoaded(
        confirmed: _confirmed,
        pending: _pending,
        hasNext: _hasNext,
      ));
    } catch (e) {
      emit(ContactsError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreConfirmed(
    LoadMoreConfirmedContactsEvent event,
    Emitter<ContactsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ContactsLoaded || currentState.isLoadingMore || !_hasNext) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final user = await _authRepository.getCurrentUser();
      if (user == null) return;

      _currentPage++;
      final paginatedConfirmed = await _getConfirmedContactsUseCase(
        user.id,
        pageNo: _currentPage,
        pageSize: _pageSize,
      );

      _confirmed = [..._confirmed, ...paginatedConfirmed.content];
      _hasNext = paginatedConfirmed.hasNext;

      emit(ContactsLoaded(
        confirmed: _confirmed,
        pending: _pending,
        hasNext: _hasNext,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
      emit(ContactsError(message: e.toString()));
    }
  }

  Future<void> _onAddContact(
    AddContactEvent event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user == null) return;

      await _addContactUseCase(
        userId: user.id,
        name: event.name,
        email: event.email,
      );
      emit(AddContactSuccess());
      add(LoadContactsEvent()); // Refresh lists
    } on DioException catch (e) {
      if (e.response != null) {
        // Backend responded with an error (e.g. 404 User Not Found)
        emit(AddContactFailure());
      } else {
        emit(ContactsError(message: e.message ?? 'Network error'));
      }
    } catch (e) {
      emit(ContactsError(message: e.toString()));
    }
  }

  Future<void> _onRemoveContact(
    RemoveContactEvent event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      await _removeContactUseCase(event.contactId);
      _confirmed = _confirmed.where((c) => c.id != event.contactId).toList();
      emit(RemoveContactSuccess());
      emit(ContactsLoaded(
        confirmed: _confirmed,
        pending: _pending,
        hasNext: _hasNext,
      ));
    } catch (e) {
      emit(ContactsError(message: e.toString()));
    }
  }

  Future<void> _onAcceptContact(
    AcceptContactEvent event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      await _respondToContactRequestUseCase(event.contactId, 'ACCEPTED');
      add(LoadContactsEvent()); // Refresh to update both lists
    } catch (e) {
      emit(ContactsError(message: e.toString()));
    }
  }

  Future<void> _onDeclineContact(
    DeclineContactEvent event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      await _respondToContactRequestUseCase(event.contactId, 'DECLINED');
      add(LoadContactsEvent());
    } catch (e) {
      emit(ContactsError(message: e.toString()));
    }
  }

  void _onSearchContacts(
    SearchContactsEvent event,
    Emitter<ContactsState> emit,
  ) {
    final query = event.query.toLowerCase().trim();
    final currentState = state;
    if (currentState is! ContactsLoaded) return;

    if (query.isEmpty) {
      emit(currentState.copyWith(filtered: []));
      return;
    }

    final filteredConfirmed = _confirmed
        .where((c) =>
            c.name.toLowerCase().contains(query) ||
            c.email.toLowerCase().contains(query))
        .toList();
    final filteredPending = _pending
        .where((c) =>
            c.name.toLowerCase().contains(query) ||
            c.email.toLowerCase().contains(query))
        .toList();

    emit(currentState.copyWith(
      filtered: [...filteredConfirmed, ...filteredPending],
    ));
  }
}
