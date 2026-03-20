import '../repositories/contacts_repository.dart';
class RemoveContactUseCase {
  final ContactsRepository repository;
  RemoveContactUseCase(this.repository);
  /// Deleted contacts are immediately removed from alert routing
  Future<void> call({required String id}) => repository.removeContact(id: id);
}
