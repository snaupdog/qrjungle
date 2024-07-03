import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/bottomnavbar/profile.dart';
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

  getUserdata() async {
    Apiss().listUserDetails();
    Apiss().listFavourites();
    Apiss().listmyqrs();
  }

  getloginstatus() async {
    print('******* LOGINSTATUS CALLED *********8');
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool loggedin = pref.getBool('loggedin') ?? false;
    print("loggedin from sp: $loggedin");
    setState(() {
      loggedinmain = loggedin;
    });

    getUserdata();
  }

  bool loady = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('OTP Verification', style: TextStyle(fontSize: 28)),
            SizedBox(height: 190),
            Text('Enter OTP sent to', style: TextStyle(fontSize: 22)),
            Text(widget.email,
                style: TextStyle(fontSize: 20, color: Colors.amber)),
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
                inactiveColor: Color.fromARGB(255, 255, 255, 255),
                activeColor: Color.fromARGB(255, 255, 255, 255),
                selectedColor: Colors.amber,
              ),
              onCompleted: (value) async {
                setState(() {
                  loady = true;
                });
                var otpStatus = await confirmSignIn(value, context);
                setState(() {
                  loady = false;
                });
                print('This is OTPSTATUS: $otpStatus');
                if (otpStatus == 'Success') {
                  print('OTP Verification Successful');

                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  await pref.setBool('loggedin', true);

                  Fluttertoast.showToast(
                      msg: "OTP Verification Successful!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: const Color.fromARGB(134, 0, 0, 0),
                      textColor: Colors.white,
                      fontSize: 18.0);

                  getloginstatus();

                  Navigator.pop(context);
                  Navigator.pop(context);
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
            SizedBox(height: 15),
            (loady)
                ? Column(
                    children: [
                      Text('Verifying'),
                      SizedBox(
                        height: 5,
                      ),
                      SpinKitThreeBounce(color: Colors.white, size: 25),
                    ],
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
