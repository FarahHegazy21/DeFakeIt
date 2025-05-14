import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../../../core/constant/APIs_constants.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;
  String? _errorMessage;
  String? _email;
  int _remainingTime = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadEmail();
    _startTimer();
  }

  Future<void> _loadEmail() async {
    final email = await _storage.read(key: 'reset_email');
    setState(() {
      _email = email;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        _timer.cancel();
      }
    });
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyCode() async {
    if (_email == null || _email!.isEmpty) {
      setState(() {
        _errorMessage = 'Session expired. Please start again.';
      });
      return;
    }

    final code = _controllers.map((c) => c.text).join();
    if (code.length != 6) {
      setState(() {
        _errorMessage = 'Please enter the full 6-digit code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse(
            '${APIsConstants.baseURL}${APIsConstants.verifyCodeEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _email,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await _storage.write(
            key: 'reset_token', value: responseData['reset_token']);
        Navigator.pushNamed(context, '/createNewPassword');
      } else {
        setState(() {
          _errorMessage = 'Invalid code. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resendCode() async {
    if (_email == null || _email!.isEmpty || _remainingTime > 0) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _remainingTime = 60;
    });

    _startTimer();

    try {
      final response = await http.post(
        Uri.parse(
            '${APIsConstants.baseURL}${APIsConstants.forgotPasswordEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _email}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New code sent successfully'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to resend code. Try again later.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.white,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Verify\n',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                            height: 1.1,
                          ),
                        ),
                        TextSpan(
                          text: 'Account!',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF1E2961),
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 38),
                  Text(
                    'Enter the 6-digit code sent to ${_email ?? 'your email'}',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF8F9193),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 48,
                        height: 58,
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          onChanged: (value) => _onChanged(value, index),
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E2961),
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: const Color(0xFFF6F6F6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      );
                    }),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 22),
                  Center(
                    child: TextButton(
                      onPressed:
                          _remainingTime > 0 || _isLoading ? null : _resendCode,
                      child: Text(
                        _remainingTime > 0
                            ? 'Resend code in $_remainingTime seconds'
                            : 'Resend Code',
                        style: GoogleFonts.poppins(
                          color: _remainingTime > 0
                              ? Colors.grey
                              : const Color(0xFF1E2961),
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E2961),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Verify',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
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
}
