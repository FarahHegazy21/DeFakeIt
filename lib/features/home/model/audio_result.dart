class AudioResult {
  final bool isFake;
  final double confidence;
  final String message;

  // Constructor
  AudioResult({
    required this.isFake,
    required this.confidence,
    required this.message,
  });

  factory AudioResult.fromJson(Map<String, dynamic> json) {
    return AudioResult(
      isFake: json['isFake'],
      confidence: json['confidence'].toDouble(),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isFake': isFake,
      'confidence': confidence,
      'message': message,
    };
  }
}
