import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class LoginUserUseCase {
  final AuthRepository repository;
  LoginUserUseCase(this.repository);

  Future<UserEntity> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}
