import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/themes.dart';

class LoginModalSheet extends StatefulWidget {
  final TextEditingController emailController;
  final Future<String> Function(String username) signInCustomFlow;
  final VoidCallback onSuccess;

  const LoginModalSheet({
    Key? key,
    required this.emailController,
    required this.signInCustomFlow,
    required this.onSuccess,
  }) : super(key: key);

  @override
  _LoginModalSheetState createState() => _LoginModalSheetState();
}

class _LoginModalSheetState extends State<LoginModalSheet> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextTheme _texttheme = Theme.of(context).textTheme;
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
            Form(
              key: formkey,
              child: TextFormField(
                controller: widget.emailController,
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
                  if (EmailValidator.validate(widget.emailController.text) ==
                      true) {
                    String result = await widget
                        .signInCustomFlow(widget.emailController.text);
                    if (result == 'Success') {
                      print('Signed in Successfully, Enter OTP');
                      Navigator.pop(context); // Close the login modal sheet
                      widget.onSuccess();
                    } else {
                      await Apiss().signup(widget.emailController.text);
                      String result2 = await widget
                          .signInCustomFlow(widget.emailController.text);
                      if (result2 == 'Success') {
                        print('Signed in Successfully, Enter OTP');
                        Navigator.pop(context); // Close the login modal sheet
                        widget.onSuccess();
                      } else {
                        Fluttertoast.showToast(
                            msg: "Something went wrong, please try again!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color.fromARGB(134, 0, 0, 0),
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
                        backgroundColor: Color.fromARGB(134, 0, 0, 0),
                        textColor: Colors.white,
                        fontSize: 18.0);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(110, 16, 110, 16),
                  child: Text('Submit',
                      style:
                          _texttheme.bodySmall?.copyWith(color: Colors.black)),
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
      ),
    );
  }
}
