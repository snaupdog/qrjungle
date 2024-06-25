import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPVerify extends StatelessWidget {
  final String email;

  const OTPVerify({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter OTP sent to $email'),
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
              onCompleted: (value) {
                print('Completed');                
                Navigator.pop(context);
                showToast('This is normal toast with animation',
                  context: context,
                  animation: StyledToastAnimation.scale,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
