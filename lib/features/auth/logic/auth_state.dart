abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {
  final String? message;
  Unauthenticated({this.message});
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class HistoryLoading extends AuthState {}

class HistoryLoaded extends AuthState {
  final List<Map<String, dynamic>> history;
  HistoryLoaded({required this.history});
}

class HistoryError extends AuthState {
  final String message;
  HistoryError({required this.message});
}
