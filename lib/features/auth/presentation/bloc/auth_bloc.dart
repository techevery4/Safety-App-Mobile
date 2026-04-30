import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/register_user_usecase.dart';
import '../../domain/usecases/login_user_usecase.dart';
import '../../domain/usecases/setup_profile_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../../../core/services/storage/onboarding_storage_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUserUseCase _registerUseCase;
  final LoginUserUseCase _loginUseCase;
  final SetupProfileUseCase _setupProfileUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;
  final OnboardingStorageService _onboardingStorage;

  AuthBloc({
    required RegisterUserUseCase registerUseCase,
    required LoginUserUseCase loginUseCase,
    required SetupProfileUseCase setupProfileUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUseCase logoutUseCase,
    required OnboardingStorageService onboardingStorage,
  })  : _registerUseCase = registerUseCase,
        _loginUseCase = loginUseCase,
        _setupProfileUseCase = setupProfileUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _logoutUseCase = logoutUseCase,
        _onboardingStorage = onboardingStorage,
        super(AuthInitial()) {
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLoginRequested>(_onLogin);
    on<AuthSetupProfileRequested>(_onSetupProfile);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthCheckOnboardingStage>(_onCheckOnboardingStage);
  }

  Future<void> _onRegister(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _registerUseCase(
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );
      emit(AuthRegistrationSuccess(user));
    } catch (e) {
      emit(AuthError(_extractErrorMessage(e)));
    }
  }

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _loginUseCase(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_extractErrorMessage(e)));
    }
  }

  Future<void> _onSetupProfile(
    AuthSetupProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _setupProfileUseCase(
        id: event.userId,
        firstName: event.firstName,
        lastName: event.lastName,
      );
      emit(AuthProfileSetupSuccess(user));
    } catch (e) {
      emit(AuthError(_extractErrorMessage(e)));
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _logoutUseCase();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(_extractErrorMessage(e)));
    }
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _getCurrentUserUseCase();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onCheckOnboardingStage(
    AuthCheckOnboardingStage event,
    Emitter<AuthState> emit,
  ) async {
    final stage = _onboardingStorage.getStage();
    final userId = _onboardingStorage.getUserId();
    final email = _onboardingStorage.getEmail();
    emit(AuthOnboardingStageResolved(
      stage: stage,
      userId: userId,
      email: email,
    ));
  }

  /// Extract a user-friendly error message from exceptions.
  String _extractErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return error.toString();
  }
}
