import 'package:defakeit/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
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

  String _getConfidenceLevel() {
    final percentage = confidence * 100;
    if (percentage >= 75) return 'HIGH';
    if (percentage <= 59) return 'LOW';
    return 'NORMAL';
  }

  @override
  Widget build(BuildContext context) {
    final confidencePercentage = (confidence * 100).toStringAsFixed(0);
    final color = isFake ? Colors.red : Colors.green;
    final resultText = isFake ? "Fake" : "Real";
    final description = isFake
        ? "Detected unusual pitch changes. Likely AI-generated."
        : "Authentic audio typically has natural patterns in pitch and tone.";
    final confidenceLevel = _getConfidenceLevel();

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
          child: SingleChildScrollView(
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
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'Uploaded: $uploadDate',
                  style: Theme.of(context).textTheme.bodyMedium,
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: color),
                    textAlign: TextAlign.center,
                  ),
                  progressColor: color,
                  backgroundColor: Colors.grey.shade200,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      "Confidence Level:",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "$confidenceLevel",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: color, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _showFeedbackDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        "Feedback",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text("Share With"),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset('assets/images/fb_icon.png', width: 35),
                      onPressed: () => _shareResult('facebook'),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: Image.asset('assets/images/ig_icon.png', width: 35),
                      onPressed: () => _shareResult('instagram'),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: Image.asset('assets/images/X_icon.png', width: 35),
                      onPressed: () => _shareResult('x'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
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
              title: const Text("Send Feedback"),
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Your feedback",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (feedbackType == null || controller.text.isEmpty) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Please select type and enter feedback"),
                        ),
                      );
                      return;
                    }

                    final success = await sendFeedback(
                      feedbackType!,
                      controller.text,
                    );

                    Navigator.pop(ctx);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(success ? Icons.check : Icons.error,
                                color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              success
                                  ? "Feedback submitted successfully"
                                  : "Failed to submit feedback",
                            ),
                          ],
                        ),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  },
                  child: const Text("Submit"),
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
    } else if (platform == 'instagram') {
      url = "https://www.instagram.com/?text=$message";
    } else {
      url = "https://twitter.com/intent/tweet?text=$message";
    }

    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
