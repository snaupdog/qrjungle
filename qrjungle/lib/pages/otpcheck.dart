import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPVerify extends StatefulWidget {
  final String email;

  const OTPVerify({Key? key, required this.email}) : super(key: key);

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  confirmSignIn(code, context) async {
    try {
      final result = await Amplify.Auth.confirmSignIn(confirmationValue: code);
      print('ressssss ' '${result.isSignedIn}');
      if (result.isSignedIn == false) {
        print('not signed in');
        return "Error";
      } else {
        print('success');
        return "Success";
      }
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('OTP Verification'),
            Text('Enter OTP sent to ${widget.email}'),
            const SizedBox(height: 40),
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
                inactiveColor: const Color.fromARGB(206, 155, 255, 158),
                activeColor: const Color(0xFFD7A937),
                selectedColor: const Color(0xFFD7A937),
              ),
              onCompleted: (value) async {
                var otpStatus = await confirmSignIn(value, context);
                print('This is OTPSTATUS: $otpStatus');
                if (otpStatus == 'Success') {
                  print('OTP Verification Successful');

                  SharedPreferences pref = await SharedPreferences.getInstance();
                  await pref.setBool('loggedin', true);

                  Fluttertoast.showToast(
                      msg: "OTP Verification Successful!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: const Color.fromARGB(134, 0, 0, 0),
                      textColor: Colors.white,
                      fontSize: 18.0);

                  Navigator.popUntil(context, (route) => route.isFirst);
                } else {
                  Fluttertoast.showToast(
                      msg: "Incorrect OTP Entered, please try again!",
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: const Color.fromARGB(134, 0, 0, 0),
                      textColor: Colors.white,
                      fontSize: 18.0);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
