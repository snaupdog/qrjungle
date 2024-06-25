import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPVerify extends StatelessWidget {
  final String email;

  const OTPVerify({Key? key, required this.email}) : super(key: key);

  confirmSignIn(code, context) async {
    try {
      final result = await Amplify.Auth.confirmSignIn(confirmationValue: code);
      print('ressssss ' '${result.isSignedIn}');
      if (result.isSignedIn == false) {
        print('not signed in');
        //showError

        // showDialogError(context, 'Please enter the correct OTP');
      } else {
        print('success');
        return "Success";
      }
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter OTP sent to $email'),
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
              onCompleted: (value) async {
                var otpStatus = await confirmSignIn(value, context);
                print('This is OTPSTATUS: $otpStatus');
                if (otpStatus == 'Success') {
                  print('OTP Verification Successful');
                  showToast(
                    position: StyledToastPosition.top,
                    backgroundColor: const Color.fromARGB(255, 45, 45, 45),
                    'OTP Verification Successful!',
                    context: context,
                    animation: StyledToastAnimation.slideFromTop,
                    textStyle: _textTheme.bodyMedium?.copyWith(color: Colors.green),
                  );                  
                } else {
                  showToast(
                    position: StyledToastPosition.top,
                    backgroundColor: Colors.grey[800],
                    'Incorrect OTP, please try again!',
                    context: context,
                    animation: StyledToastAnimation.slideFromTop,
                    textStyle: _textTheme.bodyMedium?.copyWith(color: Colors.red),
                  );                  
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
