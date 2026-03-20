import '../repositories/contacts_repository.dart';
import '../entities/contact_entity.dart';
class GetContactsUseCase {
  final ContactsRepository repository;
  GetContactsUseCase(this.repository);
  Future<List<ContactEntity>> call() => repository.getContacts();
}
