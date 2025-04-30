import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import your main screen here, e.g.
// import 'package:your_app/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/welcome');
      // OR: Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3E0EF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/defakeitt.png',
                width: 90,
                height: 90,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'De',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF233C7B),
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                  TextSpan(
                    text: 'Fake',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF2D5BBA),
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                  TextSpan(
                    text: 'It',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFB0B4BB),
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Audio Detector',
              style: GoogleFonts.poppins(
                color: const Color(0xFF233C7B),
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
