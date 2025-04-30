import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/theme.dart';
import '../logic/auth_bloc.dart';
import '../logic/auth_event.dart';
import '../logic/auth_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image (optional)
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
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
                        "Create Account",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Color(0xFFA4A3A3),
                          fontSize: 42,
                        ),
                      ),
                      const SizedBox(height: 65),

                      // Username field
                      TextField(
                        controller: usernameController,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          hintText: 'Username',
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Email field
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          hintText: 'Email Address',
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Password field
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          hintText: 'Password',
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sign up button
                      SizedBox(
                        width: double.infinity,
                        child: BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is Authenticated) {
                              // عند التسجيل بنجاح، نعرض SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Registration successful!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pushReplacementNamed(context, '/home'); // توجيه لصفحة الرئيسية
                            }
                            if (state is AuthError) {
                              // في حالة حدوث خطأ، نعرض SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message), // عرض رسالة الخطأ
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            return ElevatedButton(
                              onPressed: () {
                                final username = usernameController.text.trim();
                                final email = emailController.text.trim();
                                final password = passwordController.text.trim();

                                // إرسال event للتسجيل
                                context.read<AuthBloc>().add(SignUpRequested(
                                  username: username,
                                  email: email,
                                  password: password,
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.secondaryColor,
                                minimumSize: Size(80, 20),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text(
                                'Sign Up',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            );
                          },
                        )
                      ),
                      const SizedBox(height: 12),

                      // Already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: Text(
                              'Log In',
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