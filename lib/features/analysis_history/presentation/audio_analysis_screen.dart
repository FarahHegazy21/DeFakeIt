import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/theme.dart';

class AudioAnalysisScreen extends StatelessWidget {
  final String audioName;
  final bool isFake;
  final double confidence;
  final String uploadDate;
  final String notes;
  final String format;
  final double size;

  const AudioAnalysisScreen({
    super.key,
    required this.audioName,
    required this.isFake,
    required this.confidence,
    required this.uploadDate,
    required this.notes,
    required this.format,
    required this.size,
  });

  final String facebookUrl = 'https://www.facebook.com';
  final String instagramUrl = 'https://www.instagram.com';
  final String twitterUrl = 'https://www.twitter.com';

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
              color: isDarkMode ? Colors.white.withOpacity(0.2) : null,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_new,
                            color: AppTheme.secondaryColor),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            audioName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 185,
                    height: 185,
                    child: CustomPaint(
                      painter: GradientCircularPainter(
                        strokeWidth: 18.0,
                        percent: confidence,
                        isFake: isFake,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${(confidence * 100).toInt()}%",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: isFake ? Colors.red : Colors.green,
                              ),
                            ),
                            Text(
                              isFake ? "Fake" : "Real",
                              style: TextStyle(
                                fontSize: 18,
                                color: isFake ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Confidence Level:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1B1C20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        confidence >= 0.8
                            ? "High"
                            : confidence >= 0.5
                                ? "Medium"
                                : "Low",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: confidence >= 0.8
                              ? Colors.green
                              : confidence >= 0.5
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Analyzed on $uploadDate",
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xFF1B1C20)),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Analysis Notes",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B1C20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      notes,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF1B1C20)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Format & Size",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B1C20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$format, $size",
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF1B1C20)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Source",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B1C20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Uploaded via app.",
                      style: TextStyle(fontSize: 14, color: Color(0xFF1B1C20)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Share With",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B1C20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => _launchURL(facebookUrl),
                        child:
                            Image.asset('assets/images/fb_icon.png', width: 35),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () => _launchURL(instagramUrl),
                        child:
                            Image.asset('assets/images/ig_icon.png', width: 35),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () => _launchURL(twitterUrl),
                        child:
                            Image.asset('assets/images/X_icon.png', width: 35),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Custom Painter with gradient color logic
class GradientCircularPainter extends CustomPainter {
  final double strokeWidth;
  final double percent;
  final bool isFake;

  GradientCircularPainter({
    required this.strokeWidth,
    required this.percent,
    required this.isFake,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final startAngle = -90.0 * 3.1416 / 180.0;
    final sweepAngle = 2 * 3.1416 * percent;

    final colors = isFake
        ? [Colors.red.shade700, Colors.red.shade700]
        : [Colors.green.shade700, Colors.green.shade700];

    final gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: 3.1416 * 2,
      // stops: [0.0, percent * 0.7, percent],
      colors: colors,
    );

    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    final bgPaint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.shade300;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      startAngle + sweepAngle,
      2 * 3.1416 - sweepAngle,
      false,
      bgPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
