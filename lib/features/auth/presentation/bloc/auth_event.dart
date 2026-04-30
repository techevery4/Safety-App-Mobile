import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
  @override
  List<Object?> get props => [email, password, confirmPassword];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthSetupProfileRequested extends AuthEvent {
  final String userId;
  final String firstName;
  final String lastName;
  const AuthSetupProfileRequested({
    required this.userId,
    required this.firstName,
    required this.lastName,
  });
  @override
  List<Object?> get props => [userId, firstName, lastName];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}

class AuthCheckOnboardingStage extends AuthEvent {}
