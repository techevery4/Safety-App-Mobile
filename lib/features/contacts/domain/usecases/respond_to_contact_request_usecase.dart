import '../entities/contact_entity.dart';
import '../repositories/contacts_repository.dart';

class RespondToContactRequestUseCase {
  final ContactsRepository _repository;

  RespondToContactRequestUseCase(this._repository);

  Future<ContactEntity> call(String requestId, String status) async {
    return _repository.respondToRequest(requestId, status);
  }
}
