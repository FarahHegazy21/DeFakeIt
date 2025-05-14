import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set status bar to dark icons for light background
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
              // color: isDarkMode ? Colors.white.withOpacity(0.2) : null,
            ),
          ),
          Column(
            children: [
              // Top branding image (banner or logo)
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Image.asset(
                  'assets/images/defakeitt.png',
                  width: 120, // for logo, or use MediaQuery for banner
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 36),
              // Main title
              Text(
                "Let's Get",
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 28,
                ),
              ),
              Text(
                "Started!",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF233C7B),
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 38),
              // Sign In button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF233C7B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Log In',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // Or sign in with
              Text(
                'Or Log In With',
                style: GoogleFonts.poppins(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 14),
              // Social icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialIcon(
                    icon: Icons.facebook,
                    color: const Color(0xFF233C7B),
                    onTap: () {},
                  ),
                  const SizedBox(width: 24),
                  _socialIcon(
                    icon: Icons.g_mobiledata,
                    color: const Color(0xFF233C7B),
                    onTap: () {},
                    isGoogle: true,
                  ),
                ],
              ),
              const Spacer(),
              // Divider and bottom text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Column(
                  children: [
                    const Divider(
                      color: Color(0xFFB0B4BB),
                      thickness: 0.7,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't Have an Account? ",
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF233C7B),
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget _socialIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isGoogle = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFB0B4BB), width: 1),
        ),
        child: Center(
          child: isGoogle
              ? Icon(Icons.g_mobiledata, color: color, size: 32)
              : Icon(icon, color: color, size: 24),
        ),
      ),
    );
  }
}
