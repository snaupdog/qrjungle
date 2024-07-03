import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrjungle/main.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

bool loggedinmain = false;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List myqrslist = [];
  String email = '';
  bool isloading = true;

  @override
  void initState() {
    getloginstatus();
    super.initState();
    getuserDetails();
  }

  getuserDetails() async {
    if (email == "") {
      setState(() {
        email = Apiss.userdetailslist[0]['user_name'];
      });
    }
  }

  Future<String> signInCustomFlow(String username) async {
    print('email is: $username');
    await Amplify.Auth.signOut();
    // ignore: unused_local_variable
    final num = emailController.text;
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

  getloginstatus() async {
    print('******* LOGINSTATUS CALLED *********8');
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool loggedin = pref.getBool('loggedin') ?? false;
    print("loggedin from sp: $loggedin");
    setState(() {
      loggedinmain = loggedin;
    });
  }

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(12, 80, 12, 80),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(9.0, 0.0, 9.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Image.asset('assets/logo.png', height: 200)),
              const SizedBox(height: 30),
              Skeletonizer(
                enabled: isloading,
                enableSwitchAnimation: true,
                child: Column(
                  children: [
                    Center(
                        child: (!loggedinmain)
                            ? TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage())).then(
                                    (value) {
                                      getloginstatus();
                                    },
                                  );
                                },
                                label: const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                                  child: Text(
                                    'Log In',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                                icon: const Padding(
                                  padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                                  child: Icon(Icons.exit_to_app_outlined,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              )
                            : Text(
                                email,
                                style: const TextStyle(fontSize: 19),
                              )),
                    const SizedBox(height: 30),
                    TextButton.icon(
                      onPressed: () {},
                      label: const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                        ),
                      ),
                      icon: const Icon(Icons.info_outline,
                          color: Color.fromARGB(255, 255, 255, 255), size: 20),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      label: const Text(
                        'Terms and Conditions',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                        ),
                      ),
                      icon: const Icon(Icons.info_outline,
                          color: Color.fromARGB(255, 255, 255, 255), size: 20),
                    ),
                    (!loggedinmain)
                        ? Container()
                        : TextButton.icon(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        const Color.fromARGB(255, 21, 21, 21),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    title: const Text('Log Out',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    content: const Text(
                                        'Are you sure you want to log out?',
                                        style: TextStyle(fontSize: 16)),
                                    actions: <Widget>[
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () async {
                                          Apiss.myqrslist = [];
                                          Apiss.myfavslist = [];
                                          Apiss.userdetailslist = [];
                                          SharedPreferences pref =
                                              await SharedPreferences
                                                  .getInstance();
                                          await pref.remove('loggedin');
                                          setState(() {
                                            email = "";
                                          });
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Config(
                                                      onboarded: true,
                                                    )),
                                            (route) => false,
                                          );
                                          Fluttertoast.showToast(
                                              msg: "You've been logged out!",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 2,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      134, 0, 0, 0),
                                              textColor: Colors.white,
                                              fontSize: 18.0);
                                        },
                                        child: const Text('Yes',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: const Text('No',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white)),
                                      ),
                                    ],
                                    elevation: 5.0,
                                  );
                                },
                              );
                            },
                            label: const Text('Log Out',
                                style: TextStyle(color: Colors.white)),
                            icon: const Icon(Icons.logout, color: Colors.white),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
