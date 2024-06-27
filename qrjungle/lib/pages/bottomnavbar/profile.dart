import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/loginpage.dart';
import 'package:qrjungle/pages/qrcardgrid.dart';
import 'package:qrjungle/pageselect.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool loggedinmain = false;
String email ='';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List myqrslist = [];


  @override
  void initState() {
    getloginstatus();
    super.initState();
  getuserDetails();
  }

  getuserDetails() async {
    if(email==""){
       var res = await Apiss().listUserDetails();
    print('Email: ${res[0]['user_name']}');
    setState(() {
      email = res[0]['user_name'];
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
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(9.0, 0.0, 9.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              (!loggedinmain)
                  ? Container()
                  : TextButton.icon(
                      onPressed: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        await pref.clear();
                        Fluttertoast.showToast(
                            msg: "Logged Out!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: const Color.fromARGB(134, 0, 0, 0),
                            textColor: Colors.white,
                            fontSize: 18.0);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PageSelect(initialIndex: 2)),
                            (route) => false);
                      },
                      label: const Text('Log Out',
                          style: TextStyle(color: Colors.white)),
                      icon: const Icon(Icons.logout, color: Colors.white),
                    ),
              Center(child: Image.asset('assets/logo.png', height: 200)),
              Center(
                child: (!loggedinmain)
                    ? TextButton.icon(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage())).then((value) {
                           
                            getloginstatus();
                          },);
                        },
                        label: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 22,
                            ),
                          ),
                        ),
                        icon: const Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                          child: Icon(Icons.exit_to_app_outlined,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(255, 32, 32, 32)),
                        ),
                      )
                    : Text(email)
              ),
              SizedBox(height: 20),
              const Center(
                child: Text(
                  'My QRs',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              (!loggedinmain)
                  ? Container(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 33, 33, 33)),
                      child: const Center(
                        child: Text('Log in to purchase your first QR!'),
                      ),
                    )
                  : Container(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      width: MediaQuery.sizeOf(context).width,
                      child: const Qrcardgrid(type: "myqrs", categoryName: "")),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  children: [
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