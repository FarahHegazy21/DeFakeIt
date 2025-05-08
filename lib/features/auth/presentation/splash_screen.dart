import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../logic/auth_bloc.dart';
import '../logic/auth_event.dart';
import '../logic/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Auth check
    context.read<AuthBloc>().add(AppStarted());

    // Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is Unauthenticated) {
          Navigator.pushReplacementNamed(context, '/welcome');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.pushReplacementNamed(context, '/welcome');
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFD3E0EF),
        body: Center(
          child: FadeTransition(
            opacity: _animation,
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
        ),
      ),
    );
  }
}
