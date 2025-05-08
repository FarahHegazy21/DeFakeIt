import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:defakeit/core/constant/APIs_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../core/APIs/post_login.dart';
import '../../../core/APIs/post_signUp.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _storage = const FlutterSecureStorage();

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<GetHistoryRequested>(_onGetHistoryRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    // Attempt Auto-Login
    String? email = await _storage.read(key: 'email');
    String? password = await _storage.read(key: 'password');
    String? token = await _storage.read(key: 'token');

    if (email != null && password != null) {
      const maxRetries = 3;
      for (int attempt = 1; attempt <= maxRetries; attempt++) {
        try {
          final newToken = await login(email, password, rememberMe: true);
          if (newToken != null) {
            await _storage.write(key: 'token', value: newToken);
            emit(Authenticated(token: newToken)); // تمرير الـ token هنا
            return;
          } else {
            await _storage.deleteAll();
            emit(Unauthenticated(
                message:
                "Login credentials have changed. Please log in again."));
            return;
          }
        } on http.ClientException catch (e) {
          if (e.message.contains('timeout') && attempt == maxRetries) {
            emit(Unauthenticated(
                message: "Server is offline. Please try again later."));
            return;
          }
        } catch (e) {
          if (attempt == maxRetries) {
            await _storage.deleteAll();
            emit(Unauthenticated(
                message:
                "Auto-login failed after $maxRetries attempts. Please try again."));
            return;
          }
        }
        await Future.delayed(
            Duration(seconds: attempt * 2)); // Exponential backoff
      }
    } else if (token != null) {
      emit(Authenticated(token: token)); // تمرير الـ token هنا
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final token = await login(event.email, event.password,
          rememberMe: event.rememberMe);
      if (token != null) {
        await _storage.write(key: 'token', value: token);
        emit(Authenticated(token: token)); // تمرير الـ token هنا
      } else {
        emit(AuthError("Invalid credentials"));
      }
    } catch (e) {
      emit(AuthError("Login failed: $e"));
    }
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final token = await signup(event.username, event.email, event.password,
          rememberMe: event.rememberMe);
      if (token != null) {
        await _storage.write(key: 'token', value: token);
        emit(Authenticated(token: token)); // تمرير الـ token هنا
      } else {
        emit(AuthError("Sign up failed"));
      }
    } catch (e) {
      emit(AuthError("Sign up error: $e"));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    await _storage.deleteAll();
    emit(Unauthenticated());
  }

  Future<void> _onGetHistoryRequested(
      GetHistoryRequested event, Emitter<AuthState> emit) async {
    emit(HistoryLoading());
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        emit(HistoryError(message: 'Token not found.'));
        return;
      }

      final response = await http.get(
        Uri.parse('${APIsConstants.baseURL}/history'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> history =
        data.cast<Map<String, dynamic>>();
        emit(HistoryLoaded(history: history));
      } else if (response.statusCode == 401) {
        await _storage.deleteAll();
        emit(Unauthenticated(message: "Session expired. Please log in again."));
      } else {
        emit(HistoryError(message: 'Failed to load history: ${response.body}'));
      }
    } on http.ClientException catch (e) {
      if (e.message.contains('timeout')) {
        emit(HistoryError(
            message: 'Server is offline. Please try again later.'));
      } else {
        emit(HistoryError(message: e.toString()));
      }
    } catch (e) {
      emit(HistoryError(message: e.toString()));
    }
  }
}