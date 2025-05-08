import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:defakeit/core/constant/APIs_constants.dart';

Future<String?> login(String email, String password,
    {bool rememberMe = true}) async {
  final url =
      Uri.parse('${APIsConstants.baseURL}${APIsConstants.logInEndPoint}');
  final storage = const FlutterSecureStorage();

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'] as String?;
      if (token != null) {
        if (rememberMe) {
          await storage.write(key: 'email', value: email);
          await storage.write(key: 'password', value: password);
          await storage.write(key: 'token', value: token);
        }
        print("Login Success. Token: $token");
        return token;
      }
    }
    print("Login Failed: ${response.body}");
    return null;
  } catch (e) {
    print("Login Error: $e");
    return null;
  }
}
