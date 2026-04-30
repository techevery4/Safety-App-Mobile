import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/services/storage/onboarding_storage_service.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthRegistrationSuccess extends AuthState {
  final UserEntity user;
  const AuthRegistrationSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthProfileSetupSuccess extends AuthState {
  final UserEntity user;
  const AuthProfileSetupSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthOnboardingStageResolved extends AuthState {
  final OnboardingStage stage;
  final String? userId;
  final String? email;
  const AuthOnboardingStageResolved({
    required this.stage,
    this.userId,
    this.email,
  });
  @override
  List<Object?> get props => [stage, userId, email];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}
