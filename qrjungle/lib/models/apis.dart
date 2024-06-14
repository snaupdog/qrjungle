// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart';

class Apiss {
  listAllQrs() async {
    try {
      var operation = Amplify.API.query(
          request: GraphQLRequest(
              document: '''query ListAllQrs(\$nextToken: String) {
    listAllQrs(nextToken: \$nextToken)
  }'''));

      var response = await operation.response;

      var body = jsonDecode(response.data);
      print(response);
      print("body: $body");
    } catch (e) {
      print("list qrs erro$e");

      return "Error";
    }
  }

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

    print(response.statusCode);
    print(response.body);

    if (response.body == "201") {
      print('sigup  created successfully!');
    } else {
      print('Failed to create sigup.');
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
