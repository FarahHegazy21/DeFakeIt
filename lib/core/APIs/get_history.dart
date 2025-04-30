import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> getHistory(String token) async {
  final url = Uri.parse('http://10.0.2.2:5000/history');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    print("Failed to fetch history: ${response.body}");
    return [];
  }
}
