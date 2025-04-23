import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DetectionResultScreen extends StatelessWidget {
  final bool isFake;
  final double confidence;

  const DetectionResultScreen({
    super.key,
    required this.isFake,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    final confidencePercentage = (confidence * 100).toStringAsFixed(0);
    final color = isFake ? Colors.red : Colors.green;
    final resultText = isFake ? "Fake" : "Real";
    final description = isFake
        ? "Detected unusual pitch changes. Likely AI-generated."
        : "Authentic audio typically has natural patterns in pitch and tone.";

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF5F5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Detection Results",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 13.0,
                percent: confidence.clamp(0.0, 1.0),
                center: Text(
                  "$confidencePercentage% /n$resultText",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: color),
                  textAlign: TextAlign.center,
                ),
                progressColor: color,
                backgroundColor: Colors.grey.shade200,
                circularStrokeCap: CircularStrokeCap.round,
              ),
              const SizedBox(height: 20),
              Text("Confidence Level: $confidence",
                  style: TextStyle(color: Colors.green)),
              const SizedBox(height: 20),
              Text(description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton("Save", context),
                  const SizedBox(width: 10),
                  _buildActionButton("Cancel", context),
                  const SizedBox(width: 10),
                  _buildActionButton("Feedback", context),
                ],
              ),
              const SizedBox(height: 40),
              const Text("Share With"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.facebook, color: Colors.blue),
                  SizedBox(width: 20),
                  Icon(Icons.mail, color: Colors.black),
                  SizedBox(width: 20),
                  Icon(Icons.close, color: Colors.black),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3E3C6D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
