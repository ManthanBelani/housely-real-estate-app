import 'package:flutter/material.dart';
import 'package:real_estate_app/widgets/auth_header_footer.dart';
import 'package:real_estate_app/widgets/reusable_button.dart';

import '../../widgets/reusable_text_field.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 50,bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: AuthHeader(
                title: 'Create New Password',
                subtitle: 'Please Enter New Password to change',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PasswordTextField(
                labelText: 'New Password',
                hintText: 'Enter your new password',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PasswordTextField(
                labelText: 'Confirm Password',
                hintText: 'Confirm your new password',
              ),
            ),
            SizedBox(height: 350,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReusableButton(text: 'Change Password',),
            ),
          ],
        ),
      ),
    );
  }
}
