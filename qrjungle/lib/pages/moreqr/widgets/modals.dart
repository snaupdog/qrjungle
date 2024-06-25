import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qrjungle/models/apis_signup.dart';
import 'package:qrjungle/themes.dart';

class LoginModalSheet extends StatefulWidget {
  final TextEditingController emailController;
  final Future<String> Function(String username) signInCustomFlow;
  final Function showOtpSheet;

  const LoginModalSheet({
    Key? key,
    required this.emailController,
    required this.signInCustomFlow,
    required this.showOtpSheet,
  }) : super(key: key);

  @override
  _LoginModalSheetState createState() => _LoginModalSheetState();
}

class _LoginModalSheetState extends State<LoginModalSheet> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextTheme _texttheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formkey,
              child: TextFormField(
                controller: widget.emailController,
                style: _texttheme.bodySmall,
                decoration: InputDecoration(
                  hintText: 'Enter Email ID',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: ElevatedButton(
                onPressed: () async {
                  if (EmailValidator.validate(widget.emailController.text) == true) {
                    String result = await widget.signInCustomFlow(widget.emailController.text);
                    if (result == 'Success') {
                      print('Signed in Successfully, Enter OTP');
                      widget.showOtpSheet();
                    } else {
                      await ApissSignup().signup(widget.emailController.text);
                      String result2 = await widget.signInCustomFlow(widget.emailController.text);
                      if (result2 == 'Success') {
                        print('Signed in Successfully, Enter OTP');
                        widget.showOtpSheet();
                      } else {
                        print('Something went wrong, please try again!');
                      }
                    }
                  } else {
                    print('Invalid Email ID Entered!');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(110, 16, 110, 16),
                  child: Text('Submit', style: _texttheme.bodySmall?.copyWith(color: Colors.black)),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: accentcolor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OTPModalSheet extends StatelessWidget {
  const OTPModalSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter OTP Sent To Registered Email ID'),
            SizedBox(height: 40),
            PinCodeTextField(
              keyboardType: TextInputType.number,
              autoFocus: true,
              enablePinAutofill: true,
              appContext: context,
              length: 6,
              onChanged: (value) {
                print(value);
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                inactiveColor: Color.fromARGB(206, 155, 255, 158),
                activeColor: Color(0xFFD7A937),
                selectedColor: Color(0xFFD7A937),
              ),
              onCompleted: (value) {
                print('Completed');
              },
            ),
          ],
        ),
      ),
    );
  }
}