import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String?> signup(String username, String email, String password) async {
  final url = Uri.parse('http://127.0.0.1:5000/signup');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final token = data['token'];
    print("Signup Success. Token: $token");
    return token;
  } else {
    print("Signup Failed: ${response.body}");
    return null;
  }
}
