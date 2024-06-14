// ignore_for_file: avoid_print
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  late SharedPreferences prefs;
  final String pass = "12345";

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('otp_validation_done'));
    print(prefs.getString('otp'));
    // You can retrieve a stored value here if needed
    // Example: prefs.getString('otp') ?? 'No OTP saved';
  }

  void _storeOtp(String otp) {
    prefs.setString('otp', otp);
    prefs.setBool('otp_validation_done', true);
  }

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Hello"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PinCodeTextField(
              length: 5,
              appContext: context,
              // onCompleted: (value) {
              //   if (value == pass) {
              //     print("valid otp");
              //     _storeOtp(value); // Store the OTP when it is valid
              //   } else {
              //     print("invalid otp");
              //   }
              // },
              onSubmitted: (value) {
                print("done");
              },
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
              ),
              cursorColor: Colors.black,
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              keyboardType: TextInputType.number,
              boxShadows: const [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black12,
                  blurRadius: 10,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
