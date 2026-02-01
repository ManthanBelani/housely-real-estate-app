import 'package:flutter/material.dart';
import 'package:real_estate_app/constant/constant_color.dart';
import 'package:real_estate_app/Service/auth_service.dart';

import '../../widgets/auth_header_footer.dart';
import '../../widgets/reusable_button.dart';
import '../../widgets/reusable_text_field.dart';
import 'email_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: AuthHeader(
                  title: 'Forgot Password',
                  subtitle:
                      'Enter your email address and we will send you a password reset link',
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: EmailTextField(
                  controller: _emailController,
                  hintText: 'Enter your email address',
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReusableButton(
                  onPressed: _isLoading ? null : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      
                      try {
                        await _authService.sendPasswordResetEmail(_emailController.text.trim());
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                          
                          // Show success message
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Success'),
                                content: const Text('Password reset email has been sent to your email address. Please check your inbox.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // Navigate back to login screen
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                          
                          String errorMessage = 'An error occurred. Please try again.';
                          if (e is String && e.contains('user-not-found')) {
                            errorMessage = 'No account found with this email address.';
                          } else if (e is String && e.contains('invalid-email')) {
                            errorMessage = 'Please enter a valid email address.';
                          }
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                  text: 'Send Reset Link',
                  backgroundColor: commonColor,
                  textColor: Colors.white,
                  isLoading: _isLoading,
                ),
              ),
              
              // Back to login button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back to Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
