import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show RawKeyDownEvent, FilteringTextInputFormatter, LogicalKeyboardKey;
import 'package:real_estate_app/widgets/auth_header_footer.dart';
import 'package:real_estate_app/widgets/reusable_button.dart';

import 'new_password_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  void _verifyOtp() {
    String otp = _controllers.map((controller) => controller.text).join();
    if (otp.length == 4) {
      print("Entered OTP: $otp");
      if (otp == "0000") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Verified Successfully!")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid OTP. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter all 4 digits.")),
      );
    }
  }

  Widget _buildOtpBox(int index) {
    return RawKeyboardListener(
      focusNode: FocusNode(debugLabel: "OtpBoxRawKeyboard_$index"),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace) {
          // If the current field is empty, move to the previous field and clear it
          if (_controllers[index].text.isEmpty && index > 0) {
            _controllers[index - 1].clear();
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
          // If the current field has text, the TextField's onChanged will handle clearing it
        }
      },
      child: SizedBox(
        width: 60,
        height: 60,
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            counterText: "",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index < _focusNodes.length - 1) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else {
                _focusNodes[index].unfocus();
                _verifyOtp();
              }
            } else if (index > 0) {
              // When the current field is cleared (e.g., by backspace), move to previous and clear it
              _controllers[index - 1].clear();
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: AuthHeader(
                title: 'Verify your Email',
                subtitle:
                    'Please enter 4 digit verification that have been sent to your email address',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200, bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  _controllers.length,
                  (index) => _buildOtpBox(index),
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  'Don\'t receive code ?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Resend code', style: TextStyle(color: Colors.red)),
              ],
            ),
            SizedBox(height: 150),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReusableButton(text: 'Verify',onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewPasswordScreen(),));
              },),
            ),
          ],
        ),
      ),
    );
  }
}
