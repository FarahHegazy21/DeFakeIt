import 'package:defakeit/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background pattern
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 38),
                  // Title: "Forgot Password!"
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Forgot\n',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF8F9193),
                            fontWeight: FontWeight.w500,
                            fontSize: 32,
                            height: 1.2,
                          ),
                        ),
                        TextSpan(
                          text: 'Password!',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF1E2961),
                            fontWeight: FontWeight.w700,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    'Please Enter Your Email Address To Receive a Verification Code.',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF8F9193),
                      fontSize: 13.5,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Email field
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFFB0B0B0),
                          size: 20,
                        ),
                        hintText: 'Email Address',
                        hintStyle: GoogleFonts.poppins(
                          color: const Color(0xFFB0B0B0),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Send button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/verification');
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor),
                      child: Text(
                        'Send',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Sign In link
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Go Back To? ',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF8F9193),
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigation logic for sign in
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF1E2961),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
