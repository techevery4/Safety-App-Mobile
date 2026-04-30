import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<UserEntity> call({
    required String id,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return _repository.changePassword(
      id: id,
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
