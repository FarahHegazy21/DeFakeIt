import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/theme.dart';
import 'analysis_history_screen.dart';

class Audio2Screen extends StatelessWidget {
  const Audio2Screen({super.key});

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
          // ✅ Background Image with all visual effects
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

          // ✅ Rest of Content
          SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios_new , color: AppTheme.secondaryColor,)
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: const Text(
                            "Audio 2",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25), // space after ring
                  SizedBox(
                    width: 185,
                    height: 185,
                    child: CustomPaint(
                      painter: GradientCircularPainter(
                        strokeWidth: 18.0,
                        percent: 0.8,
                        gradient: const SweepGradient(
                          startAngle: 0.0,
                          endAngle: 3.14 * 2,
                          stops: [0.0, 0.27, 0.53, 1.0],
                          colors: [
                            Color(0xFFC4C4C4),
                            Color(0xFFE06065),
                            Color(0xFFED5258),
                            Color(0xFFB14246),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "80%",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB14246),
                              ),
                            ),
                            Text(
                              "Fake",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFFB14246),
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
                    children: const [
                      Text(
                        "Confidence Level:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1B1C20),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "High",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF34A853),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Analyzed on Oct 2, 2024, 8:00 AM",
                    style: TextStyle(fontSize: 14, color: Color(0xFF1B1C20)),
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Detected unusual pitch changes. Likely AI-generated.",
                      style: TextStyle(fontSize: 14, color: Color(0xFF1B1C20)),
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "MP3, 3.5 MB",
                      style: TextStyle(fontSize: 14, color: Color(0xFF1B1C20)),
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

// 🎯 Custom Painter for Gradient Ring
class GradientCircularPainter extends CustomPainter {
  final double strokeWidth;
  final double percent;
  final SweepGradient gradient;

  GradientCircularPainter({
    required this.strokeWidth,
    required this.percent,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final startAngle = -90.0 * 3.1415926535 / 180.0;
    final sweepAngle = 2 * 3.1415926535 * percent;

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
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
