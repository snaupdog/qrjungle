//import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/apis.dart';
import 'package:qrjungle/dashboard.dart';
import 'package:qrjungle/main.dart';
import 'package:qrjungle/otp.dart';
import 'package:qrjungle/themes.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  TextEditingController logincontroller = TextEditingController();
  ApiS apiService = ApiS();

  @override
  void initState() {
    super.initState();
  }

  Future signInCustomFlow(String username) async {
    print(' email is:  $username');
    await Amplify.Auth.signOut();
    //final num = "${emailController.text}";
    try {
      final result = await Amplify.Auth.signIn(username: username);
      print(result);
      return 'Success';
    } on AuthException catch (e) {
      print("error");
      print("message: ${e.message}");
      if (e.message.contains('NOT_AUTHORIZED')) {
        //add print
        await ApiS().signin(emailController.text);
        return 'Error';
      }
      // return e.message;
    }
  }

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool loader = false;

    TextTheme _texttheme = Theme.of(context).textTheme;
    late bool whatisbrightness;
    if (themeselector.thememode == ThemeMode.light) {
      whatisbrightness = true;
    } else {
      whatisbrightness = false;
    }
    String logoimage = whatisbrightness ? 'logo_invert.png' : 'logo.png';
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),
        child: Stack(
          children: [
            Positioned(
              top: 25,
              right: 0,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: Icon(
                  Icons.arrow_circle_right_sharp,
                  color: whatisbrightness ? secondarycolor : accentcolor,
                ),
                label: Text(
                  'Skip',
                  style: TextStyle(
                    color: whatisbrightness ? secondarycolor : accentcolor,
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/$logoimage',
                        height: 225,
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: formkey,
                        child: TextFormField(
                          controller: emailController,
                          style: _texttheme.bodySmall
                              ?.copyWith(color: whatisbrightness ? secondarycolor : primarycolor),
                          decoration: InputDecoration(
                            hintText: 'Enter Email ID',
                            hintStyle: TextStyle(color: whatisbrightness ? secondarycolor : primarycolor), 

                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: whatisbrightness ? secondarycolor : primarycolor),),

                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: whatisbrightness ? secondarycolor : primarycolor), ),

                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: whatisbrightness ? secondarycolor : primarycolor), ),

                            errorStyle: TextStyle(
                                height: 0,
                                color: Colors.transparent),

                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: whatisbrightness ? secondarycolor : primarycolor),),

                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: whatisbrightness ? secondarycolor : primarycolor),),
                          ),
                          validator: (value) {
                            if (EmailValidator.validate(value!)) {
                              return '';
                            } else {
                              return '';
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 25),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: accentcolor,
                            ),
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Invalid Email ID'),
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 0, 0),
                                ));
                              } else {
                                setState(() {
                                  loader = false;
                                });

                                var res = await signInCustomFlow(
                                    emailController.text);
                                if (res == 'Success') {
                                  setState(() {
                                    loader = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OTP(emailController.text)));
                                } else {
                                  var res2 = await signInCustomFlow(
                                      emailController.text);
                                  setState(() {
                                    loader = false;
                                  });
                                  if (res2 == 'Success') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OTP(emailController.text)));
                                  } else {
                                    AnimatedSnackBar(
                                      builder: ((context) {
                                        return const MaterialAnimatedSnackBar(
                                          messageText:
                                              'Couldn\'t sign you in.', messageTextStyle: TextStyle(color: Colors.black, fontSize: 18),
                                          type: AnimatedSnackBarType.error,
                                          foregroundColor: Color.fromARGB(255, 0, 0, 0),
                                          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
                                        );
                                      }),
                                    ).show(context);
                                  }
                                }
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 20, 10, 20),
                              child: (loader == true)
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ))
                                  : Text(
                                      'Submit',
                                      style: _texttheme.bodyMedium,
                                    ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
