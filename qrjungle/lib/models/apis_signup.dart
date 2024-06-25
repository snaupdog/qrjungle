import 'dart:convert';
import 'package:http/http.dart';

class ApissSignup {
  signup(String email) async {
    final url = Uri.parse('https://hciu6m7wcj.execute-api.ap-south-1.amazonaws.com/prod/user_signup');
    final response = await post(
      url,
      headers: {'Content-Type':'application/json'},
      body: json.encode({
        'user_name':email,
        'user_email_id':email,
        'command':'userSignUp',
      })
    );

    var body = json.decode(
      response.body
    );

    print("user: $body");
  }  
}

