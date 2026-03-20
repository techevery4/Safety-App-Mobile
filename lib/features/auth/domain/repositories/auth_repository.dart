import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> register({required String email, required String password});
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity> verifyOtp({required String email, required String otp});
  Future<void> resendOtp({required String email});
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}
