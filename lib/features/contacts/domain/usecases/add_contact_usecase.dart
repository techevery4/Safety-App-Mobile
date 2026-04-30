import '../entities/contact_entity.dart';
import '../repositories/contacts_repository.dart';

/// Use case to add a new contact by name and email.
class AddContactUsecase {
  final ContactsRepository _repository;

  AddContactUsecase(this._repository);

  Future<ContactEntity> call({
    required String userId,
    required String name,
    required String email,
  }) async {
    return _repository.addContact(
      userId: userId,
      name: name,
      email: email,
    );
  }
}
