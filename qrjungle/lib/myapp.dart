// ignore_for_file: avoid_print
// import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/models/apis.dart';
import 'package:qrjungle/tesing.dart';
import 'qr_cards.dart';
// import 'package:http/http.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black87,
      body: LoginCard(),
    );
  }
}

class LoginCard extends StatefulWidget {
  const LoginCard({
    super.key,
  });
  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  // Constructor

  final emailController = TextEditingController();
  final otpcontroller = TextEditingController();
  bool isvalid = true;

  Future signInCustomFlow() async {
    // i removed username
    print(' email is:  ${emailController.text}');
    await Amplify.Auth.signOut();
    try {
      final result = await Amplify.Auth.signIn(username: emailController.text);
      print(result);
      return 'Success';
    } on AuthException catch (e) {
      print("message: ${e.message} err in signInCustomFlow");
      if (e.message.contains('NOT_AUTHORIZED')) {
        await Apiss().signup(emailController.text);
        print("signging up");
        //call api to do sign up here
        //add print
      }

      // return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Background image from the internet

        Positioned(
          top: 20,
          left: 20,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Teasoigm()),
                );
                // Define the action to take when the "Skip" button is pressed.
              },
              child: const Text('Skip'),
            ),
          ),
        ),

        Positioned(
          top: 20,
          right: 20,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const qrCards()),
                );
                // Define the action to take when the "Skip" button is pressed.
              },
              child: const Text('Skip'),
            ),
          ),
        ),

        Positioned(
          bottom: 20,
          right: 20,
          child: SizedBox(
            width: 100,
            height: 100,
            child: TextField(
              controller: otpcontroller,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),

        Positioned(
          bottom: 90,
          right: 20,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
            child: ElevatedButton(
              onPressed: () {
                Apiss().confirmSignIn(otpcontroller.text);
                // Define the action to take when the "Skip" button is pressed.
              },
              child: const Text('otpconfirmer'),
            ),
          ),
        ),

        Center(
          child: Card(
            color: Colors.black54,
            elevation: 30.0,
            margin: const EdgeInsets.all(40.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Enter a vaild email',
                    ),
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await signInCustomFlow();
                    },
                    child: const Text('Login'),
                  ),
                  if (!isvalid)
                    const Text(
                      "wrong username or password",
                    ),
                ],
              ),
            ),
          ),
        ),

        // Other widgets can be added here
      ],
    );
  }
}
