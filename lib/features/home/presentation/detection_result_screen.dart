import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/APIs/post_feedback.dart';

class DetectionResultScreen extends StatelessWidget {
  final bool isFake;
  final double confidence;
  final String audioName;
  final String uploadDate;
  final String? message;

  const DetectionResultScreen({
    super.key,
    required this.isFake,
    required this.confidence,
    required this.audioName,
    required this.uploadDate,
    this.message,
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
              const Text(
                "Detection Results",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Audio: $audioName',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Uploaded: $uploadDate',
                style: const TextStyle(fontSize: 16),
              ),
              if (message != null) ...[
                const SizedBox(height: 10),
                Text(
                  'Message: $message',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
              const SizedBox(height: 30),
              CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 13.0,
                percent: confidence.clamp(0.0, 1.0),
                center: Text(
                  "$confidencePercentage%\n$resultText",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
                progressColor: color,
                backgroundColor: Colors.grey.shade200,
                circularStrokeCap: CircularStrokeCap.round,
              ),
              const SizedBox(height: 20),
              Text(
                "Confidence Level: $confidencePercentage%",
                style: TextStyle(color: color),
              ),
              const SizedBox(height: 20),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton("Save", () => _saveResult(context)),
                  const SizedBox(width: 10),
                  _buildActionButton("Cancel", () => Navigator.pop(context)),
                  const SizedBox(width: 10),
                  _buildActionButton(
                    "Feedback",
                    () => _showFeedbackDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text("Share With"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.facebook, color: Colors.blue),
                    onPressed: () => _shareResult('facebook'),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.mail, color: Colors.black),
                    onPressed: () => _shareResult('email'),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => _shareResult('x'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3E3C6D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  void _saveResult(BuildContext context) {
    // TODO: ANALYSIS LIBRARY SCREEN INTEGRATION
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Result saved to your library.")),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    String? feedbackType;
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text(
                "Send Feedback",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: "Good",
                        groupValue: feedbackType,
                        onChanged: (value) =>
                            setState(() => feedbackType = value),
                      ),
                      const Text("Good"),
                      const SizedBox(width: 20),
                      Radio<String>(
                        value: "Issue",
                        groupValue: feedbackType,
                        onChanged: (value) =>
                            setState(() => feedbackType = value),
                      ),
                      const Text("Issue"),
                    ],
                  ),
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      label: Text(
                        "Write your feedback...",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFFA4A3A3),
                            ),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final feedbackText = controller.text.trim();

                    if (feedbackType == null || feedbackText.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please select feedback type and write a comment.",
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.of(ctx).pop();

                    // Send Feedback
                    final success = await sendFeedback(
                      feedbackType!,
                      feedbackText,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? "Feedback submitted successfully."
                              : "Failed to send feedback. Please check your connection or token.",
                        ),
                        duration: const Duration(seconds: 5),
                      ),
                    );

                    if (!success) {
                      // Optionally navigate to login if token is invalid
                      final storage = const FlutterSecureStorage();
                      final token = await storage.read(key: 'token');
                      if (token == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Session expired. Please log in again."),
                          ),
                        );
                        // Add navigation to login screen if needed
                      }
                    }
                  },
                  child: Text(
                    "Submit",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _shareResult(String platform) {
    final message = "Detection Result: ${isFake ? "Fake" : "Real"}\n"
        "Confidence: ${(confidence * 100).toStringAsFixed(1)}%\n"
        "Audio: $audioName\n"
        "Uploaded: $uploadDate";

    String url;
    if (platform == 'facebook') {
      url =
          "https://www.facebook.com/sharer/sharer.php?u=https://example.com=$message";
    } else if (platform == 'email') {
      url = "mailto:?subject=Detection Result&body=$message";
    } else {
      url = "https://twitter.com/intent/tweet?text=$message";
    }

    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
