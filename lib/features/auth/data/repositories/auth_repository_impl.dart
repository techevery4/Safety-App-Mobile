import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  // TODO: inject data sources

  @override
  Future<UserEntity> register({required String email, required String password}) async {
    // TODO: implement — email must be unique (backend-enforced; show inline error)
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    // TODO: implement — session persists until explicit logout
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> verifyOtp({required String email, required String otp}) async {
    // TODO: implement — after successful verification, user is auto-logged in
    throw UnimplementedError();
  }

  @override
  Future<void> resendOtp({required String email}) async {
    // TODO: implement
  }

  @override
  Future<void> logout() async {
    // TODO: implement
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // TODO: implement
    return null;
  }
}
