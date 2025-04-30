import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthEvent {}


class SignUpRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;

  SignUpRequested({
    required this.username,
    required this.email,
    required this.password,
  });
}

class GetHistoryRequested extends AuthEvent {}


