import 'dart:convert';

import 'package:http/http.dart' as http;

Future<bool> sendFeedback(String token, String type, String text) async {
  final url = Uri.parse('http://10.0.2.2:5000/feedback');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'feedback_type': type, // "Good" or "Issue"
      'feedback_text': text,
    }),
  );

  if (response.statusCode == 200) {
    print("Feedback sent");
    return true;
  } else {
    print("Feedback failed: ${response.body}");
    return false;
  }
}
