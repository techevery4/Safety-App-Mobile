import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthRegisterRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthVerifyOtpRequested extends AuthEvent {
  final String email;
  final String otp;
  const AuthVerifyOtpRequested({required this.email, required this.otp});
  @override
  List<Object?> get props => [email, otp];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}
