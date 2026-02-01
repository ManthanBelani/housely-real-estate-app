import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Added for date formatting
import 'package:real_estate_app/constant/constant_color.dart';
import 'package:real_estate_app/Service/auth_service.dart';

import 'package:real_estate_app/widgets/reusable_text_field.dart';
import 'package:real_estate_app/widgets/reusable_button.dart';
import 'package:real_estate_app/widgets/social_media_button.dart';
import 'package:real_estate_app/widgets/auth_header_footer.dart';

import 'login_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isLoading = false;
  String? _errorMessage;
  final _signUpFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _termsAccepted = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  String _parseFirebaseError(String error) {
    if (error.contains('email-already-in-use')) {
      return 'Email is already in use. Please try another email.';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email format. Please enter a valid email.';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak. Please use at least 6 characters.';
    } else if (error.contains('operation-not-allowed')) {
      return 'Email/password accounts are not enabled.';
    } else {
      return 'An error occurred during sign up. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _signUpFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const AuthHeader(title: 'Register Account'),
              const SizedBox(height: 20),
              EmailTextField(controller: _emailController),
              const SizedBox(height: 20),
              ReusableTextField(
                Tstyle: TextStyle(fontWeight: FontWeight.bold),
                labelText: 'UserName',
                hintText: 'Enter your username',
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              PasswordTextField(
                  labelText: 'Password',
                  controller: _passwordController),
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
              Row(
                children: [
                  Checkbox(
                    activeColor: commonColor,
                    value: _termsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Agree with Terms and Privacy',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
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
              const SizedBox(height: 10),
              ReusableButton(
                text: 'Sign Up',
                onPressed: _termsAccepted
                    ? () async {
                        if (_signUpFormKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                            _errorMessage = null;
                          });
                          
                          try {
                            await _authService.signUpWithEmail(
                              _emailController.text.trim(),
                              _passwordController.text,
                              _usernameController.text,
                            );
                            
                            // If successful, navigate to login
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Sign up successful! Please log in.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => LoginScreen()),
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
                      }
                    : null, // Disable button if terms not accepted
                isLoading: _isLoading,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 100),
                child: Center(
                  child: Text('Or', style: TextStyle(fontSize: 15)),
                ),
              ),
              SocialMediaButtonsRow(
                onFacebookPressed: () {
                  // TODO: Implement Facebook Sign-Up
                  print('Facebook sign-up pressed');
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
                        MaterialPageRoute(builder: (_) => const LoginScreen()), // Navigate to login or home
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
                text: 'Already have account ?',
                linkText: 'Sign In',
                linkColor: commonColor,
                onLinkTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
