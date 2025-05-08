abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  LoginRequested(
      {required this.email, required this.password, this.rememberMe = true});
}

class SignUpRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final bool rememberMe;

  SignUpRequested({
    required this.username,
    required this.email,
    required this.password,
    this.rememberMe = true,
  });
}

class LogoutRequested extends AuthEvent {}

class GetHistoryRequested extends AuthEvent {}

class UpdateUserRequested extends AuthEvent {
  final String? email;
  final String? password;

  UpdateUserRequested({this.email, this.password});
}