import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<void> uploadAudio(File audioFile, String token) async {
  final url = Uri.parse('http://10.0.2.2:5000/upload_audio'); // استخدم 10.0.2.2 لو emulator

  final request = http.MultipartRequest('POST', url)
    ..headers['Authorization'] = 'Bearer $token'
    ..files.add(await http.MultipartFile.fromPath(
      'audio',
      audioFile.path,
      contentType: MediaType('audio', 'mpeg'), // أو audio/wav حسب نوع الملف
    ));

  final response = await request.send();

  if (response.statusCode == 200) {
    final respStr = await response.stream.bytesToString();
    print("Upload Success: $respStr");
  } else {
    print("Upload Failed: ${response.statusCode}");
  }
}
