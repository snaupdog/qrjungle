// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:qrjungle/pages/otpcheck.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<String> signInCustomFlow(String username) async {
    print('email is: $username');
    await Amplify.Auth.signOut();
    try {
      final result = await Amplify.Auth.signIn(username: username);
      print('Result@@@@@@@@@@@!!!!!!: $result');
      return 'Success';
    } on AuthException catch (e) {
      print("error");
      print("message: ${e.message}");
      if (e.message.contains('No password was provided')) {
        await Apiss().signup(emailController.text);
      }
      return e.message;
    }
  }

  bool loader = false;
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(25, 240, 25, 240),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(9.0, 0.0, 9.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Image.asset('assets/logo.png', height: 200)),
                const SizedBox(height: 50),
                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: emailController,
                    style: textTheme.bodySmall,
                    decoration: const InputDecoration(
                      hintText: 'Enter Email ID',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || !EmailValidator.validate(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        setState(() {
                          loader = true;
                        });

                        String result =
                            await signInCustomFlow(emailController.text);

                        setState(() {
                          loader = false;
                        });

                        if (result == 'Success') {
                          print('Signed in Successfully, Enter OTP');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OTPVerify(email: emailController.text),
                            ),
                          );
                        } else {
                          setState(() {
                            loader = true;
                          });
                          await Apiss().signup(emailController.text);
                          String result2 =
                              await signInCustomFlow(emailController.text);
                          setState(() {
                            loader = false;
                          });
                          if (result2 == 'Success') {
                            print('Signed in Successfully, Enter OTP');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OTPVerify(email: emailController.text),
                              ),
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: "Something went wrong, please try again!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    const Color.fromARGB(134, 0, 0, 0),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Invalid Email ID Entered",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: const Color.fromARGB(134, 0, 0, 0),
                            textColor: Colors.white,
                            fontSize: 18.0);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.white),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                        child: (loader)
                            ? const Center(
                                child: SpinKitThreeBounce(
                                    color: Colors.white, size: 23),
                              )
                            : Text('Submit',
                                style: textTheme.bodySmall?.copyWith(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
