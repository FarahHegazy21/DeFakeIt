class AudioResult {
  final bool isFake;
  final double confidence;
  final String message;

  AudioResult({
    required this.isFake,
    required this.confidence,
    required this.message,
  });

  factory AudioResult.fromJson(Map<String, dynamic> json) {
    return AudioResult(
      isFake: json['is_fake'] as bool,
      confidence: (json['confidence'] as num).toDouble(),
      message: json['message'] ?? '',
    );
  }
}
