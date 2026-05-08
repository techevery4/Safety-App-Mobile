import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../../../../core/services/storage/onboarding_storage_service.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final OnboardingStorageService _onboardingStorage;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required OnboardingStorageService onboardingStorage,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _onboardingStorage = onboardingStorage;

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final user = await _remoteDataSource.register(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    // Cache user data and update onboarding stage
    await _localDataSource.cacheUser(user);
    await _onboardingStorage.saveUserId(user.id);
    await _onboardingStorage.saveEmail(user.email);
    await _onboardingStorage.saveStage(OnboardingStage.registered);

    return user;
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final user = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    // Cache user data and mark onboarding as completed
    // (login implies the user has already completed onboarding)
    await _localDataSource.cacheUser(user);
    await _onboardingStorage.saveUserId(user.id);
    await _onboardingStorage.saveEmail(user.email);
    await _onboardingStorage.saveStage(OnboardingStage.completed);

    return user;
  }

  @override
  Future<UserEntity> setupProfile({
    required String id,
    required String firstName,
    required String lastName,
  }) async {
    final user = await _remoteDataSource.setupProfile(
      id: id,
      firstName: firstName,
      lastName: lastName,
    );

    // Cache updated user data and advance onboarding stage
    await _localDataSource.cacheUser(user);
    await _onboardingStorage.saveStage(OnboardingStage.profileSetup);

    return user;
  }

  @override
  Future<UserEntity> verifyOtp({
    required String email,
    required String otp,
  }) async {
    // This flow is currently skipped in the UI but the repository provides the method
    throw UnimplementedError('OTP verification is currently skipped');
  }

  @override
  Future<void> resendOtp({required String email}) async {
    // This flow is currently skipped in the UI but the repository provides the method
    throw UnimplementedError('OTP resend is currently skipped');
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearCache();
    // await _onboardingStorage.clearAll();
    // We keep the onboarding stage as 'completed' if it was already completed,
    // so the user sees the Login screen on next launch instead of Onboarding.
    // But we clear the user-specific IDs.
    await _onboardingStorage.saveUserId('');
    await _onboardingStorage.saveEmail('');
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await _localDataSource.getCachedUser();
  }

  @override
  OnboardingStage getOnboardingStage() {
    return _onboardingStorage.getStage();
  }

  @override
  Future<UserEntity> changePassword({
    required String id,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final user = await _remoteDataSource.changePassword(
      id: id,
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    await _localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    UserModel userModel;
    if (user is UserModel) {
      userModel = user;
    } else {
      // Convert UserEntity to UserModel if necessary
      // This part might need adjustment based on how UserModel is structured
      // For now, assuming we can cast or reconstruct it.
      // Since all user objects in the app should ideally be UserModels, this should be safe.
      userModel = UserModel(
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        profilePictureId: user.profilePictureId,
        profilePictureUrl: user.profilePictureUrl,
        status: user.status,
        latitude: user.latitude,
        longitude: user.longitude,
        locationText: user.locationText,
        lastIp: user.lastIp,
        lastLocationUpdate: user.lastLocationUpdate,
        lastLogin: user.lastLogin,
        settings: user.settings,
        totalAlerts: user.totalAlerts,
        alerts: user.alerts,
        createdOn: user.createdOn,
      );
    }

    final updatedUser = await _remoteDataSource.updateUser(userModel);
    await _localDataSource.cacheUser(updatedUser);
    return updatedUser;
  }
}
