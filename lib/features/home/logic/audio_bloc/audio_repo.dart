import 'dart:io';
import 'dart:math';
import '../../model/audio_result.dart';

class AudioRepo {
  Future<AudioResult> analyzeAudio(File audioFile) async {
    await Future.delayed(Duration(seconds: 2));

    final random = Random();
    bool isFake = random.nextBool();
    double confidence = random.nextDouble() * 100;
    String message = isFake ? "Audio is fake" : "Audio is real";

    return AudioResult(
      isFake: isFake,
      confidence: confidence,
      message: message,
    );
  }
}
