import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> login(String email, String password) async {
  final url = Uri.parse('http://127.0.0.1:5000/login');

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
    final token = data['token'];
    print("Login Success. Token: $token");
    return token;
  } else {
    print("Login Failed: ${response.body}");
    return null;
  }
}
