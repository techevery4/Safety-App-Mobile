import 'package:equatable/equatable.dart';

/// Events for the Contacts BLoC.
abstract class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object?> get props => [];
}

/// Load all initial contacts (pending + first page of confirmed).
class LoadContactsEvent extends ContactsEvent {}

/// Load next page of confirmed contacts.
class LoadMoreConfirmedContactsEvent extends ContactsEvent {}

/// Add a new contact by name and email.
class AddContactEvent extends ContactsEvent {
  final String name;
  final String email;

  const AddContactEvent({required this.name, required this.email});

  @override
  List<Object?> get props => [name, email];
}

/// Remove a confirmed contact by ID.
class RemoveContactEvent extends ContactsEvent {
  final String contactId;

  const RemoveContactEvent({required this.contactId});

  @override
  List<Object?> get props => [contactId];
}

/// Accept a pending contact request (move to confirmed).
class AcceptContactEvent extends ContactsEvent {
  final String contactId;

  const AcceptContactEvent({required this.contactId});

  @override
  List<Object?> get props => [contactId];
}

/// Decline a pending contact request (remove).
class DeclineContactEvent extends ContactsEvent {
  final String contactId;

  const DeclineContactEvent({required this.contactId});

  @override
  List<Object?> get props => [contactId];
}

/// Search/filter contacts by query string.
class SearchContactsEvent extends ContactsEvent {
  final String query;

  const SearchContactsEvent({required this.query});

  @override
  List<Object?> get props => [query];
}
