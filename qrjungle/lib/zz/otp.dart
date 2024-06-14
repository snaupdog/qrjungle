import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qrjungle/dashboard.dart';
import 'package:qrjungle/themes.dart';

class OTP extends StatefulWidget {
  final email;
  const OTP(this.email);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondarycolor,

      appBar: AppBar(
        backgroundColor: secondarycolor,leading: BackButton(color: Colors.white,)),
      body: Container(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           


            Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                width: MediaQuery.of(context).size.width * 1,
                child: Text(
                  'OTP VERIFICATION',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber),
                )),
            SizedBox(
              height: 8,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                width: MediaQuery.of(context).size.width * 1,
                child: Text(
                  'Please enter the 6-digit code sent to your email ${widget.email}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                )),
            SizedBox(
              height: 25,
            ),

            Container(
              height: 80,
              margin: EdgeInsets.symmetric(horizontal: 40),
              width: MediaQuery.of(context).size.width * 1,
              child: PinCodeTextField(
                textStyle: TextStyle(color: Colors.white),
                enablePinAutofill: false,
                autoFocus: true,
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                
                  background: Paint()..color = Colors.white,
                ),
                length: 6,
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
               
                pinTheme: PinTheme(
                    inactiveColor: Colors.grey,
                    selectedColor: accentcolor,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    activeColor: accentcolor,
                    inactiveFillColor: Colors.green,
                    disabledColor: Colors.yellow,
                    selectedFillColor: accentcolor,
                    borderWidth: 1),
                cursorColor: accentcolor,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: false,
                
                keyboardType: TextInputType.number,

                
                onCompleted: (v) async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Successfully Verified OTP!'),
                    backgroundColor: Color.fromARGB(206, 155, 255, 158),
                  )
                );
                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Dashboard()), (route) => false);
                },
                
                onChanged: (value) {
                  
                  
                },
                beforeTextPaste: (text) {
                 
                  return true;
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),]))
    );
  }
}