import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../model/audio_result.dart';

class AudioRepo {
  Future<AudioResult> analyzeAudio(File file) async {
    final url = Uri.parse('http://10.0.2.2:5000/upload_audio');
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('audio', file.path));

    try {
      final response = await http.Response.fromStream(
          await request.send().timeout(const Duration(seconds: 10)));

      debugPrint("📩 API Status Code: ${response.statusCode}");
      debugPrint("📦 API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AudioResult.fromJson(data);
      } else {
        throw Exception('❌ API returned status code: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      debugPrint("⚠️ ClientException occurred: $e");
      rethrow;
    } catch (e) {
      debugPrint("❌ Exception during API call: $e");
      rethrow;
    }
  }
}
