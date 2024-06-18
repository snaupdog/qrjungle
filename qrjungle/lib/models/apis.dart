// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart';

class Apiss {
  Future<String> getPresignedUrl(String key) async {
    final Map<String, String> data = {"command": "getPresignedURL", "key": key};
    final jsonData = json.encode(data);
    final response = await post(
      Uri.parse(
          'https://ppq54dc20b.execute-api.ap-south-1.amazonaws.com/production/get_presigned_url'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );

    if (response.statusCode == 200) {
      final dataa = json.decode(response.body);
      return dataa['url'];
    } else {
      throw Exception('Failed to fetch URL for key $key');
    }
  }

  getAllqrs(String nextToken) async {
    final Map<String, String> data = {"command": "listAllQrs", "nextToken": ""};
    final jsonData = json.encode(data);
    List<String> urlKeys = [];
    final response = await post(
      Uri.parse(
          'https://hciu6m7wcj.execute-api.ap-south-1.amazonaws.com/prod/list_all_qrcodes'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );
    final dataa = json.decode(response.body);
    final x = dataa['data'];
    print(x.length);
    for (var i = 0; i < x.length; i++) {
      urlKeys.add(x[i]['qr_code_image_url_key']);
    }
    print(urlKeys);
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
