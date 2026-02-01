import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final int maxLines;
  final TextStyle Tstyle;
  final String? initialValue;

  const ReusableTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
    required this.Tstyle,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.initialValue,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        const SizedBox(height: 5),
        TextFormField(
          style: TextStyle(fontWeight: FontWeight.bold),
          controller: controller,
          initialValue: initialValue,
          obscureText: isPassword,
          validator: validator,
          keyboardType: keyboardType,
          enabled: enabled,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

// Email text field with built-in validation
class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool enabled;

  const EmailTextField({
    Key? key,
    this.controller,
    this.hintText = 'Enter your email',
    this.validator,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReusableTextField(
      labelText: 'Email',
      hintText: hintText,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      enabled: enabled,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          }, Tstyle: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

// Password text field with built-in validation
class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool showSuffixIcon;
  final TextStyle? Tstyle;

  const PasswordTextField({
    super.key,
    this.controller,
    this.hintText = 'Enter your password',
    this.validator,
    this.enabled = true,
    this.showSuffixIcon = true,
    this.Tstyle,
    this.labelText,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return ReusableTextField(
      labelText: '${widget.labelText}',
      hintText: widget.hintText,
      controller: widget.controller,
      isPassword: !_isPasswordVisible, // Show password when _isPasswordVisible is true
      enabled: widget.enabled,
      validator: widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
      suffixIcon: widget.showSuffixIcon
          ? IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            )
          : null,
      Tstyle: widget.Tstyle ?? const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}