import '../../domain/repositories/contacts_repository.dart';
import '../../domain/entities/contact_entity.dart';
class ContactsRepositoryImpl implements ContactsRepository {
  /// Only registered app users can be added. Prevent duplicate contacts.
  @override
  Future<List<ContactEntity>> getContacts() async { throw UnimplementedError(); }
  @override
  Future<void> addContact({required String email}) async { throw UnimplementedError(); }
  @override
  Future<void> removeContact({required String id}) async { throw UnimplementedError(); }
}
