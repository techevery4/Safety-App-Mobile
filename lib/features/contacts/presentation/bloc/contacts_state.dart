import 'package:equatable/equatable.dart';
import '../../domain/entities/contact_entity.dart';

/// States for the Contacts BLoC.
abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded.
class ContactsInitial extends ContactsState {}

/// Loading state while fetching contacts.
class ContactsLoading extends ContactsState {}

/// Contacts loaded successfully.
class ContactsLoaded extends ContactsState {
  final List<ContactEntity> confirmed;
  final List<ContactEntity> pending;
  final List<ContactEntity> filtered;
  final bool hasNext;
  final bool isLoadingMore;

  const ContactsLoaded({
    required this.confirmed,
    required this.pending,
    this.filtered = const [],
    this.hasNext = false,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [confirmed, pending, filtered, hasNext, isLoadingMore];

  ContactsLoaded copyWith({
    List<ContactEntity>? confirmed,
    List<ContactEntity>? pending,
    List<ContactEntity>? filtered,
    bool? hasNext,
    bool? isLoadingMore,
  }) {
    return ContactsLoaded(
      confirmed: confirmed ?? this.confirmed,
      pending: pending ?? this.pending,
      filtered: filtered ?? this.filtered,
      hasNext: hasNext ?? this.hasNext,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Error state.
class ContactsError extends ContactsState {
  final String message;

  const ContactsError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Contact added successfully.
class AddContactSuccess extends ContactsState {}

/// Contact add failed (e.g. user not found).
class AddContactFailure extends ContactsState {}

/// Contact removed successfully.
class RemoveContactSuccess extends ContactsState {}
