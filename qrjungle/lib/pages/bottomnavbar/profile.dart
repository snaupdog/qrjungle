import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/models/apis_graph.dart';
import 'package:qrjungle/models/apis_signup.dart';
import 'package:qrjungle/pages/moreqr/widgets/modals.dart';
import 'package:qrjungle/pages/otpcheck.dart';

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

  Future<String> signInCustomFlow(String username) async {
    print('email is: $username');
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
        await ApissSignup().signup(emailController.text);
      }
      return e.message;
    }
  }

  TextEditingController emailController = TextEditingController();

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

  void LogInModalSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return LoginModalSheet(
          emailController: emailController,
          signInCustomFlow: signInCustomFlow,
          onSuccess: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPVerify(email: emailController.text),
              ),
            );
          },
        );
      },
    );
  }
}

