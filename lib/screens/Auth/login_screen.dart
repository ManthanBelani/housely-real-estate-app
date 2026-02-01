import 'package:flutter/material.dart';
import 'package:real_estate_app/constant/constant_color.dart';
import 'package:real_estate_app/Service/auth_service.dart';
import 'package:real_estate_app/screens/Auth/sign_up.dart';
import 'package:real_estate_app/screens/bottom_tab_nav_screen.dart';
import 'package:real_estate_app/widgets/reusable_text_field.dart';
import 'package:real_estate_app/widgets/reusable_button.dart';
import 'package:real_estate_app/widgets/social_media_button.dart';
import 'package:real_estate_app/widgets/auth_header_footer.dart';

import '../Forgot_Password/forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  final _signInFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  String _parseFirebaseError(String error) {
    if (error.contains('user-not-found')) {
      return 'No user found with this email. Please check your email.';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email format. Please enter a valid email.';
    } else if (error.contains('user-disabled')) {
      return 'This account has been disabled.';
    } else {
      return 'An error occurred during sign in. Please try again.';
    }
  }

  void _showPasswordResetDialog() {
    TextEditingController emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter your email to receive a password reset link:'),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (emailController.text.isNotEmpty && 
                    emailController.text.contains('@')) {
                  try {
                    await _authService.sendPasswordResetEmail(emailController.text.trim());
                    if (mounted) {
                      Navigator.of(context).pop(); // Close the dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password reset email sent! Please check your inbox.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      Navigator.of(context).pop(); // Close the dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid email address.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _signInFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const AuthHeader(
                title: 'Welcome Back !',
              ),
              const SizedBox(height: 20),
              EmailTextField(
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              PasswordTextField(
                labelText: 'Password',
                controller: _passwordController,
              ),
              const SizedBox(height: 20),
              // Error message container (if needed)
              // if (errorMessage.isNotEmpty)
              //   Container(
              //     padding: EdgeInsets.all(10),
              //     decoration: BoxDecoration(
              //       color: Colors.red[50],
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     child: Text(errorMessage, style: TextStyle(color: Colors.red)),
              //   ),
              // SizedBox(height: 20),
              if (_errorMessage != null)
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        activeColor: commonColor,
                        value: true,
                        onChanged: (value) {},
                      ),
                      const Text('Remember me', textAlign: TextAlign.left),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      _showPasswordResetDialog();
                    },
                    child: Text(
                      'Forgot Password?',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: commonColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              ReusableButton(
                text: 'Sign In',
                onPressed: () async {
                  if (_signInFormKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                      _errorMessage = null;
                    });
                    
                    try {
                      await _authService.signInWithEmail(
                        _emailController.text.trim(),
                        _passwordController.text,
                      );
                      
                      // If successful, navigate to home
                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const BottomTabNavScreen()),
                        );
                      }
                    } catch (e) {
                      setState(() {
                        _errorMessage = e.toString().contains('Firebase')
                            ? _parseFirebaseError(e.toString())
                            : 'An error occurred: $e';
                      });
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
                isLoading: _isLoading,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 100),
                child: Center(child: Text('Or', style: TextStyle(fontSize: 15))),
              ),
              SocialMediaButtonsRow(
                onFacebookPressed: () {
                  // TODO: Implement Facebook Sign-In
                  print('Facebook sign-in pressed');
                },
                onGooglePressed: () async {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  
                  try {
                    await _authService.signInWithGoogle();
                    
                    // If successful, navigate to home
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const BottomTabNavScreen()),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      _errorMessage = e.toString().contains('Firebase') || e.toString().contains('Google')
                          ? _parseFirebaseError(e.toString())
                          : 'An error occurred: $e';
                    });
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              AuthFooter(
                text: "Don't have account ?",
                linkText: 'Sign Up',
                linkColor: commonColor,
                onLinkTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>SignUp()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
