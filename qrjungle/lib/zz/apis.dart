import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;

class ApiS {
  signin(String email) async {
    final url = Uri.parse(
        'https://hciu6m7wcj.execute-api.ap-south-1.amazonaws.com/prod/user_signup');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_name': email,
          'user_email_id': email,
          'command': 'userSignUp',
        }));

    var body = json.decode(response.body);

    print("user: $body");
  }

  listAllQrs() async {
    try {
      var operation = Amplify.API.query(
          request: GraphQLRequest(
              document:
                  '''query ListAllQrs(\$nextToken: String) {
    listAllQrs(nextToken: \$nextToken)
  }'''
            
          ));

      var response = await operation.response;
      
      var body = jsonDecode(response.data);
      print("body: $body");
 

 
     
    } catch (e) {

      print("list qrs erro$e");
      
      return "Error";
    }
  }
}
