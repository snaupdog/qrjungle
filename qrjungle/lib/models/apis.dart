// ignore_for_file: avoid_print, non_constant_identifier_names, unused_local_variable

import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart';

class QrInfo {
  String category;
  String qr_code_id;
  String UrlKey;
  String? price;
  String? image; // Image URL which can be null initially

  QrInfo({
    required this.category,
    required this.qr_code_id,
    required this.UrlKey,
    this.price,
  });
}

class Apiss {

  listQrCategories(var next) async {
  final url = Uri.parse('https://hciu6m7wcj.execute-api.ap-south-1.amazonaws.com/prod/list_categories');

  final response = await post(
    url,
    headers : {'Content-Type' : 'application/json'},
    body: json.encode({
      'command' : 'listCategories',
      if(next!="")
      'nextToken' : next,
    })
  );

  var body = json.decode(response.body);
  log("ListAllQrs: $body");
  return body;
}

  Future getCategories() async {  
    print("asdfasasdfasdff");
    final Map<String, String> data = {"command": "listActiveCategories"};
    final jsonData = json.encode(data);
    final response = await post(
      Uri.parse(
          'https://ppq54dc20b.execute-api.ap-south-1.amazonaws.com/production/list_available_categories'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );     
    print(response.body);
  }

  Future getqrfromCategories(String categoryName) async {
    final Map<String, String> data = {
      "command": "listQrByCategory",
      "qr_code_category_name": categoryName,
    };
    final jsonData = json.encode(data);
    final response = await post(
      Uri.parse(
          'https://hciu6m7wcj.execute-api.ap-south-1.amazonaws.com/prod/list_qr_by_category'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );
  }

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

  Future<List<QrInfo>> getAllqrs(String nextToken) async {
    final Map<String, String> data = {
      "command": "listAllQrs",
      "nextToken": nextToken
    };
    List<QrInfo> allqrinfo = [];
    final jsonData = json.encode(data);
    final response = await post(
      Uri.parse(
          'https://hciu6m7wcj.execute-api.ap-south-1.amazonaws.com/prod/list_all_qrcodes'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );
    final dataa = json.decode(response.body);
    print(dataa['nextToken']);
    final x = dataa['data'];
    // print(x);

    for (var i = 0; i < x.length; i++) {
      // Fixxy -  this code was scuffed hardcoded a fix
      final hi = x[i];
      if (hi['qr_code_status'] == 'APPROVED') {
        allqrinfo.add(
          QrInfo(
            UrlKey: hi['qr_code_image_url_key'],
            category: hi['qr_code_category'],
            qr_code_id: hi['qr_code_id'],
            price: hi['price'],
          ),
        );
      }
    }
    return allqrinfo;
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


  getcurrentuserdetails()async{
    
    try {
      var operation = Amplify.API.query(
          request: GraphQLRequest(
              document:
                  '''query GetCurrentUserDetails {
    getCurrentUserDetails
  }''',
  // variables: {
  //             'input': {
  //               'customer_status': "ACTIVE",
                
  //             }
  //           }
));

      var response = await operation.response;
      print("GetCurrentUserDetails error:${response.errors}");
      print("GetCurrentUserDetails data :${response.data}");
      var body = jsonDecode(response.data);
      print("get GetCurrentUserDetails body: $body ");
    
      
    } catch (e) {
      print("GetCurrentUserDetails error :$e");
      return "Error";
    }

  }

}
