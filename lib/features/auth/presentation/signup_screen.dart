import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    // Set status bar to dark icons for light background
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image (top right, subtle)
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
            child: Center(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back arrow
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.black87, size: 22),
                      onPressed: () {Navigator.pop(context);},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(height: 12),
                    // Title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Create ',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 28,
                          ),
                        ),
                        Text(
                          'Account!',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF233C7B),
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _textField(
                            hint: 'Username',
                            icon: Icons.person_outline,
                            obscure: false,
                          ),
                          const SizedBox(height: 18),
                          _textField(
                            hint: 'Email Address',
                            icon: Icons.email_outlined,
                            obscure: false,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 18),
                          _textField(
                            hint: 'Password',
                            icon: Icons.lock_outline,
                            obscure: _obscurePassword,
                            onToggle: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          const SizedBox(height: 18),
                          _textField(
                            hint: 'Confirm Password',
                            icon: Icons.lock_outline,
                            obscure: _obscureConfirm,
                            onToggle: () {
                              setState(() {
                                _obscureConfirm = !_obscureConfirm;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Log In Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF233C7B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {},
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
                    const SizedBox(height: 24),
                    // Bottom text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {}, // Link to sign-in
                          child: Text(
                            "Sign In",
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
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onToggle,
  }) {
    return TextFormField(
      obscureText: obscure,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 15),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey[400],
          fontSize: 15,
        ),
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        suffixIcon: (hint.toLowerCase().contains('password'))
            ? IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[400],
            size: 20,
          ),
          onPressed: onToggle,
        )
            : null,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
