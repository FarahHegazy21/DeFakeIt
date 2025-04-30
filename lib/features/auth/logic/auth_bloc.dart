import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:defakeit/core/constant/APIs_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:http/http.dart' as http;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<GetHistoryRequested>(_onGetHistoryRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('loggedIn') ?? false;
    if (loggedIn) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  // Future<void> _onLoginRequested(
  //     LoginRequested event, Emitter<AuthState> emit) async {
  //   emit(AuthLoading());
  //
  //   // Simulated login check
  //   await Future.delayed(const Duration(seconds: 1));
  //
  //   // Save login state
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('loggedIn', true);
  //
  //   emit(Authenticated());
  // }
  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit
      ) async {
    emit(AuthLoading());

    final url = Uri.parse('$baseURL$logInEndPoint');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          "email": event.email,
          "password": event.password
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('loggedIn', true);
        emit(Authenticated());
      } else {
        emit(AuthError("Invalid credentials"));
      }
      print(response.body);
      print(response.statusCode);
    } catch (e) {
      print(e.toString());
      emit(AuthError("Login failed: ${e.toString()}"));
    }
  }

  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final url = Uri.parse('$baseURL$signUpEndPoint');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "username": event.username,
          "email": event.email,
          "password": event.password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('loggedIn', true);
        emit(Authenticated());
        print(response.body);
        print(response.statusCode);
      } else {
        emit(AuthError("Sign up failed: ${response.body}"));
        print(response.body);
        print(response.statusCode);
      }
    } catch (e) {
      emit(AuthError("Sign up error: ${e.toString()}"));
      print(e.toString());
    }
  }


  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedIn');
    emit(Unauthenticated());
  }

  Future<http.Response> logIn({
    required String email,
    required String password,
}) async {
    final url = Uri.https(baseURL,logInEndPoint);
    final http.Response response = await http.post(
      url,
      body: json.encode({
        "email": "test@example.com",
        "password": "test123"
      })
    );
    emit(Authenticated());
    print(response.body);
    print(response.statusCode);
    return response;
  }

  Future<void> _onGetHistoryRequested(GetHistoryRequested event, Emitter<AuthState> emit) async {
    emit(HistoryLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(HistoryError(message: 'Token not found.'));
        return;
      }

      final response = await http.get(
        Uri.https(baseURL, '/history'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> history = data.cast<Map<String, dynamic>>();
        emit(HistoryLoaded(history: history));
      } else {
        emit(HistoryError(message: 'Failed to load history.'));
      }
    } catch (e) {
      emit(HistoryError(message: e.toString()));
    }
  }
}
