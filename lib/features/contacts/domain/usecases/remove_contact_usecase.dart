import '../repositories/contacts_repository.dart';

/// Use case to remove a contact by ID.
class RemoveContactUsecase {
  final ContactsRepository _repository;

  RemoveContactUsecase(this._repository);

  Future<void> call(String contactId) async {
    return _repository.removeContact(contactId);
  }
}
