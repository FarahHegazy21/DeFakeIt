import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/audio_result.dart';

class AudioService {
  final String _baseUrl = 'http://10.0.2.2:5000';

  Future<AudioResult> analyzeAudio(File file) async {
    final uri = Uri.parse('$_baseUrl/upload_audio');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath(
      'audio',
      file.path,
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return AudioResult.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to analyze audio: ${response.body}');
    }
  }
}
