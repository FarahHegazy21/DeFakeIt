import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({Key? key}) : super(key: key);

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background pattern (subtle)
          Positioned.fill(
            child: Image.asset(
              'assets/images/Background.png',
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.97),
              colorBlendMode: BlendMode.lighten,
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
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 22,
                        color: Colors.black87,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Title: "Create New Password"
                  Text(
                    'Create',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF8F9193),
                      fontWeight: FontWeight.w500,
                      fontSize: 32,
                    ),
                  ),
                  Text(
                    'New Password',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF1F2B6C),
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // New Password field
                  _buildPasswordField(
                    controller: _passwordController,
                    hint: 'New Password',
                    isVisible: _passwordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Confirm Password field
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    hint: 'Confirm Password',
                    isVisible: _confirmPasswordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),

                  const SizedBox(height: 32),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Save password logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F2B6C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: GoogleFonts.poppins(
          color: Colors.black87,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey[400],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.grey[400],
            size: 22,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[400],
              size: 22,
            ),
            onPressed: onToggleVisibility,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
