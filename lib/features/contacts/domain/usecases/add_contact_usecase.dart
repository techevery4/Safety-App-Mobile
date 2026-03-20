import '../repositories/contacts_repository.dart';
class AddContactUseCase {
  final ContactsRepository repository;
  AddContactUseCase(this.repository);
  Future<void> call({required String email}) => repository.addContact(email: email);
}
