import 'package:flutter/material.dart';
import 'package:qrjungle/pages/loginpage.dart';

class LoginModalSheet extends StatefulWidget {

  const LoginModalSheet({
    Key? key,
  }) : super(key: key);

  @override
  _LoginModalSheetState createState() => _LoginModalSheetState();
}

class _LoginModalSheetState extends State<LoginModalSheet> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [            
            Container(
              height: MediaQuery.sizeOf(context).height*0.14,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                children: [
                  Text('Oops! You need to log in to do that!', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 15),
                  ElevatedButton(                
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>LoginPage())
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(100.0, 15, 100, 15),
                      child: Text('Log In', style: TextStyle(color: Colors.white, fontSize: 22)),
                    ),
                    style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.white),
                          ),
                          backgroundColor: Colors.transparent,                    
                    ),
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
