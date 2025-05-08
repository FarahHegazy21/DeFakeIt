import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

Future<void> uploadAudio(File audioFile, String token) async {
  final url = Uri.parse('http://10.0.2.2:5000/upload_audio');

  final mimeType = lookupMimeType(audioFile.path);

  if (mimeType != 'audio/mpeg' && mimeType != 'audio/wav') {
    print('❌ Unsupported audio format. Only MP3 and WAV are allowed.');
    return;
  }

  final type = mimeType!.split('/')[0];
  final subtype = mimeType.split('/')[1];

  final request = http.MultipartRequest('POST', url)
    ..headers['Authorization'] = 'Bearer $token'
    ..files.add(await http.MultipartFile.fromPath(
      'audio',
      audioFile.path,
      contentType: MediaType(type, subtype),
    ));

  final response = await request.send();

  if (response.statusCode == 200) {
    final respStr = await response.stream.bytesToString();
    print("✅ Upload Success: $respStr");
  } else {
    print("❌ Upload Failed: ${response.statusCode}");
  }
}
