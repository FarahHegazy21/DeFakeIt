import 'package:defakeit/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/auth_bloc.dart';
import '../logic/auth_event.dart';
import '../logic/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool rememberMe = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: Color(0xFFA4A3A3),
                                  fontSize: 42,
                                ),
                      ),
                      Text(
                        "Back!",
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 36,
                                ),
                      ),
                      const SizedBox(height: 65),
                      TextField(
                        controller: emailController,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Color(0xFFA4A3A3),
                            ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          hintText: 'Email Address',
                          hintStyle:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Color(0xFFA4A3A3),
                                  ),
                          filled: true,
                          fillColor: Color(0xFFF4F4F4),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: passwordController,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Color(0xFFA4A3A3),
                            ),
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          hintText: 'Password',
                          hintStyle:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Color(0xFFA4A3A3),
                                  ),
                          filled: true,
                          fillColor: Color(0xFFF4F4F4),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value ?? true;
                              });
                            },
                          ),
                          Text(
                            'Remember Me',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Color(0xFFA4A3A3),
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is Authenticated) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Login successful!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pushReplacementNamed(context, '/home');
                            }
                            if (state is AuthError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return ElevatedButton(
                              onPressed: () {
                                final email = emailController.text.trim();
                                final password = passwordController.text.trim();
                                context.read<AuthBloc>().add(LoginRequested(
                                      email: email,
                                      password: password,
                                      rememberMe: rememberMe,
                                    ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.secondaryColor,
                                minimumSize: Size(80, 20),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text(
                                'Log in',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgotPassword');
                          },
                          child: Text(
                            'Forget password?',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: AppTheme.textColorLightDarkBlue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don’t have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppTheme.textColorLightDarkBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
