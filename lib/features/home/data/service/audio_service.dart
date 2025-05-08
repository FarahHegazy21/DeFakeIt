import 'dart:convert';
import 'dart:io';
import 'package:defakeit/core/constant/APIs_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../model/audio_result.dart';

class AudioService {
  Future<AudioResult> uploadAudio(File audioFile, String token,
      {int retries = 3}) async {
    const maxRetries = 3; // Define maxRetries here
    for (int attempt = 1; attempt <= retries; attempt++) {
      try {
        final url = Uri.parse(
            '${APIsConstants.baseURL}${APIsConstants.uploadAudioEndpoint}');
        final request = http.MultipartRequest('POST', url)
          ..headers['Authorization'] = 'Bearer $token'
          ..files.add(await http.MultipartFile.fromPath(
            'audio',
            audioFile.path,
            contentType: MediaType(
                'audio', audioFile.path.endsWith('.wav') ? 'wav' : 'mpeg'),
          ));

        final response = await http.Response.fromStream(
            await request.send().timeout(const Duration(seconds: 120)));

        debugPrint("📩 API Status Code: ${response.statusCode}");
        debugPrint("📦 API Response Body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return AudioResult.fromJson(data);
        } else if (response.statusCode == 401) {
          debugPrint("❌ Invalid or expired token detected");
          throw InvalidTokenException('Invalid or expired token');
        } else {
          throw Exception(
              'API returned status code: ${response.statusCode} - ${response.body}');
        }
      } on http.ClientException catch (e) {
        debugPrint("⚠️ ClientException occurred: $e");
        if (e.message.contains('timeout') && attempt == maxRetries) {
          throw ServerOfflineException('Server is offline or unreachable');
        }
        if (attempt == retries) rethrow;
      } catch (e) {
        debugPrint("❌ Exception during API call: $e");
        if (attempt == retries) rethrow;
      }
      await Future.delayed(
          Duration(seconds: attempt * 2)); // Exponential backoff
    }
    throw Exception('Failed to upload audio after $retries attempts');
  }
}

// Custom exceptions
class InvalidTokenException implements Exception {
  final String message;
  InvalidTokenException(this.message);
}

class ServerOfflineException implements Exception {
  final String message;
  ServerOfflineException(this.message);
}
