import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:defakeit/core/constant/APIs_constants.dart';

Future<Map<String, dynamic>> updateUser(String username, String email,
    {bool rememberMe = true}) async {
  final url =
      Uri.parse('${APIsConstants.baseURL}${APIsConstants.updateUserEndpoint}');
  final storage = const FlutterSecureStorage();

  try {
    final token = await storage.read(key: 'token');
    if (token == null) {
      print("Update Failed: No token found");
      return {'success': false, 'message': 'No token found'};
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
      }),
    );

    print("API Status Code: ${response.statusCode}");
    print("API Response: ${response.body}");

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 && data['token'] != null) {
      final newToken = data['token'] as String?;
      final message = data['message'] as String? ??
          data['msg'] ??
          'Profile updated successfully';

      if (newToken != null) {
        await storage.write(key: 'username', value: username);
        await storage.write(key: 'email', value: email);
        await storage.write(key: 'token', value: newToken);

        print("Update Success. New Token: $newToken, Message: $message");
        return {'success': true, 'token': newToken, 'message': message};
      }
    }

    // Handle non-200 status codes or missing token
    final errorMessage = data['message'] ??
        data['error'] ??
        data['msg'] ??
        'Failed to update profile (Status: ${response.statusCode})';
    print("Update Failed: $errorMessage");
    return {'success': false, 'message': errorMessage};
  } catch (e) {
    print("Update Error: $e");
    return {'success': false, 'message': 'Error: $e'};
  }
}
