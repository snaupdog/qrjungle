// ignore_for_file: use_build_context_synchronously

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qrjungle/main.dart';
import 'package:qrjungle/models/apis_graph.dart';
import 'package:qrjungle/models/apis_signup.dart';
import 'package:qrjungle/themes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    fetchUrls();
  }

  Future<void> fetchUrls() async {
    try {
      await ApissGraph().listCustomers();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future signInCustomFlow(String username) async {
    print(' email is:  ${username}');
    await Amplify.Auth.signOut();
    // ignore: unused_local_variable
    final num = "${emailController.text}";
    try {
      final result = await Amplify.Auth.signIn(username: username);
      print('Result@@@@@@@@@@@!!!!!!: $result');
      return 'Success';
    } on AuthException catch (e) {
      print("error");
      print("message: ${e.message}");
      if (e.message.contains('No password was provided')) {
        //add print
        await ApissSignup().signup(emailController.text);
      }
      return e.message;
    }
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
      body: Container(
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/logo.png', height: 200)),
              const Divider(
                height: 45,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    LogInModalSheet(context);
                  },
                  label: const Text(
                    'Log In',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                    ),
                  ),
                  icon: const Icon(Icons.exit_to_app_outlined,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 32, 32, 32)),
                  ),
                ),
              ),
              const Text(
                'My QRs:',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Container(),
              Center(
                child: TextButton.icon(
                  onPressed: () {},
                  label: const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                    ),
                  ),
                  icon: const Icon(Icons.info_outline,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 32, 32, 32)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton.icon(
                  onPressed: () {},
                  label: const Text(
                    'Terms and Conditions',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                    ),
                  ),
                  icon: const Icon(Icons.info_outline,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 32, 32, 32)),
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController emailController = TextEditingController();

  void LogInModalSheet(BuildContext context) {
    TextTheme _texttheme = Theme.of(context).textTheme;
    showModalBottomSheet(
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Form(
                        key: formkey,
                        child: TextFormField(
                          controller: emailController,
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
                            if (EmailValidator.validate(emailController.text) ==
                                true) {
                              String result =
                                  await signInCustomFlow(emailController.text);
                              if (result == 'Success') {
                                print('Signed in Successfully, Enter OTP');
                                OTPModalSheet(context);
                              } else {
                                await ApissSignup().signup(emailController.text);
                                String result2 = await signInCustomFlow(emailController.text);
                                if (result2 == 'Success') {
                                  print('Signed in Successfully, Enter OTP');
                                  OTPModalSheet(context);
                                } else {
                                  print(
                                      'Something went wrong, please try again!');
                                }
                              }
                            } else {
                              print('Invalid Email ID Entered!');
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(110, 16, 110, 16),
                            child: Text('Submit',
                                style: _texttheme.bodySmall
                                    ?.copyWith(color: Colors.black)),
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
                ],
              ),
            ),
          );
        });
  }

  OTPModalSheet(BuildContext context) {
    
    showModalBottomSheet(
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    onCompleted: (value)  async {
                      print('VALUE! : $value');
                      String otpsuccess = await confirmSignIn(value, context);
                      if (otpsuccess == 'success'){
                        showToastWidget(Text('OTP Verification Successful!'),context:context);
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
