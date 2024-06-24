import 'dart:developer';
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart';

class ApissSignup {
  signup(String signupemailcontroller) async {
    final Map<String, String> data = {
      "user_name": signupemailcontroller,
      "user_email_id": signupemailcontroller,
      "command": "userSignUp",
    };
    final jsonData = json.encode(data);
    final response = await post(
      // Uri.parse('http://localhost:8080/data'),
      Uri.parse(
          'https://hciu6m7wcj.execute-api.ap-south-1.amazonaws.com/prod/user_signup'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );

    if (response.body == "201") {
      print('signed up successfully!');
    } else {
      print('Failed to create sign up.');
    }
  }

  confirmSignIn(code) async {
    try {
      final result = await Amplify.Auth.confirmSignIn(confirmationValue: code);
      print('user_signed_in ' '${result.isSignedIn}');
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
}
