import '../../domain/entities/contact_entity.dart';
import '../../domain/entities/paginated_contacts.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../datasources/contacts_remote_datasource.dart';

/// implementation of [ContactsRepository] using real API calls.
class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsRemoteDatasource _remoteDatasource;

  ContactsRepositoryImpl(this._remoteDatasource);

  @override
  Future<PaginatedContacts> getConfirmedContacts(
    String userId, {
    int pageNo = 0,
    int pageSize = 25,
  }) async {
    final paginatedModel = await _remoteDatasource.getConfirmedContacts(
      userId,
      pageNo: pageNo,
      pageSize: pageSize,
    );

    return PaginatedContacts(
      totalPages: paginatedModel.totalPages,
      size: paginatedModel.size,
      totalElements: paginatedModel.totalElements,
      hasNext: paginatedModel.hasNext,
      hasPrevious: paginatedModel.hasPrevious,
      content: paginatedModel.content, // ContactModel is a subclass of ContactEntity
    );
  }

  @override
  Future<List<ContactEntity>> getPendingContacts(String userId) async {
    return await _remoteDatasource.getPendingContacts(userId);
  }

  @override
  Future<ContactEntity> addContact({
    required String userId,
    required String name,
    required String email,
  }) async {
    return await _remoteDatasource.addContact(
      userId: userId,
      name: name,
      email: email,
    );
  }

  @override
  Future<void> removeContact(String id) async {
    await _remoteDatasource.removeContact(id);
  }

  @override
  Future<ContactEntity> respondToRequest(String requestId, String status) async {
    return await _remoteDatasource.respondToContactRequest(requestId, status);
  }
}
