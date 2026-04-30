import '../entities/contact_entity.dart';
import '../repositories/contacts_repository.dart';

class GetPendingContactsUseCase {
  final ContactsRepository _repository;

  GetPendingContactsUseCase(this._repository);

  Future<List<ContactEntity>> call(String userId) async {
    return _repository.getPendingContacts(userId);
  }
}
