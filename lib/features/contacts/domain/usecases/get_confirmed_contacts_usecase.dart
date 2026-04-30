import '../entities/paginated_contacts.dart';
import '../repositories/contacts_repository.dart';

class GetConfirmedContactsUseCase {
  final ContactsRepository _repository;

  GetConfirmedContactsUseCase(this._repository);

  Future<PaginatedContacts> call(
    String userId, {
    int pageNo = 0,
    int pageSize = 25,
  }) async {
    return _repository.getConfirmedContacts(
      userId,
      pageNo: pageNo,
      pageSize: pageSize,
    );
  }
}
