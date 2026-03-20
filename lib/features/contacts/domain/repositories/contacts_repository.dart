import '../entities/contact_entity.dart';
abstract class ContactsRepository {
  Future<List<ContactEntity>> getContacts();
  Future<void> addContact({required String email});
  Future<void> removeContact({required String id});
}
