import '../entities/contact_entity.dart';
import '../entities/paginated_contacts.dart';

/// Abstract repository for contact operations.
abstract class ContactsRepository {
  /// Returns confirmed contacts with pagination.
  Future<PaginatedContacts> getConfirmedContacts(
    String userId, {
    int pageNo = 0,
    int pageSize = 25,
  });

  /// Returns pending contact requests.
  Future<List<ContactEntity>> getPendingContacts(String userId);

  /// Adds a new contact.
  Future<ContactEntity> addContact({
    required String userId,
    required String name,
    required String email,
  });

  /// Removes a contact by its unique record [id].
  Future<void> removeContact(String id);

  /// Responds to a contact request (ACCEPTED or DECLINED).
  Future<ContactEntity> respondToRequest(String requestId, String status);
}
