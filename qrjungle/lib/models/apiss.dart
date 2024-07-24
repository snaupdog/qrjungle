// ignore_for_file: unused_local_variable, non_constant_identifier_names
import 'dart:convert';
import 'package:http/http.dart';

import 'package:amplify_flutter/amplify_flutter.dart';

class Apiss {
  static String preurl =
      "https://qrjungle-all-qrcodes.s3.ap-south-1.amazonaws.com/";
  static List myallqrslist = [];
  static List myqrslist = [];
  static List userdetailslist = [];
  static String qr_idpayment = "";
  static String qr_redirecturl = "";

  // Future clearlist() async {
  //   qrinfolist = [];
  // }

  getAllqrs(String nextToken) async {
    print("callig get all qrs");
    final Map<String, String> data = {
      "command": "listPortalQrs",
    };
    final jsonData = json.encode(data);
    final response = await post(
      Uri.parse(
          'https://hciu6m7wcj.execute-api.ap-south-1.amazonaws.com/prod/list_all_qrcodes'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );
    // print(dataa['nextToken']);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      var qrlist = body['data'];
      myallqrslist = qrlist;
      print(myallqrslist);
    } else {
      print(response.body);
      throw Exception("error getting all qrs");
    }
  }

  listmyqrs() async {
    print("calling list my qrs");

    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          document: '''query ListMyQrs {
          listMyQrs
        }''',
        ),
      );

      var response = await operation.response;

      // Check if the response has errors
      if (response.errors.isNotEmpty) {
        print("GraphQL Error: ${response.errors}");
        return;
      }

      var body = jsonDecode(response.data);
      var hello = body['listMyQrs'];
      var body2 = jsonDecode(hello);
      myqrslist = body2;
      print(hello);
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  listUserDetails() async {
    var operation = Amplify.API.query(
        request: GraphQLRequest(document: '''query GetCurrentUserDetails {
    getCurrentUserDetails
  }'''));

    var response = await operation.response;
    var body = jsonDecode(response.data);
    var hello = body['getCurrentUserDetails'];
    var body2 = jsonDecode(hello);
    userdetailslist = body2['data']['items'];
  }

  editRedirect(String qr_code_id, String redirect_url) async {
    var operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: '''
  mutation EditRedirectUrl(\$input: editUrlInput) {
    editRedirectUrl(input: \$input)
  }
  ''',
        variables: {
          'input': {
            "qr_code_id": qr_code_id,
            "redirect_url": redirect_url,
          }
        },
      ),
    );

    var response = await operation.response;
    Apiss().listmyqrs();
  }

  createOrder<String>(String amount, String currency) async {
    var operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: '''mutation CreateOrder(\$input: createOrderInput) {
    createOrder(input: \$input)
  }
  ''',
        variables: {
          'input': {
            'amount': amount,
            'currency': currency,
          }
        },
      ),
    );
    var response = await operation.response;
    var body = jsonDecode(response.data);
    var createOrderJson = jsonDecode(body['createOrder']);
    String orderId = createOrderJson['id'];
    return orderId;
  }

  purchaseQr(String qr_code_id, String price, String? utr_no,
      String redirect_url) async {
    var operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: '''
  mutation PuchaseQr(\$input: purchaseQrInput) {
    puchaseQr(input: \$input)
  }
  ''',
        variables: {
          'input': {
            'price': price,
            'qr_code_id': qr_code_id,
            'redirect_url': redirect_url,
          }
        },
      ),
    );
    var response = await operation.response;
    var body = jsonDecode(response.data);
    print(body);
  }

  signup(String email) async {
    final url = Uri.parse(
        'https://hciu6m7wcj.execute-api.ap-south-1.amazonaws.com/prod/user_signup');
    final response = await post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_name': email,
          'user_email_id': email,
          'command': 'userSignUp',
        }));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
    } else {
      print(response.body);
      throw Exception("error in signup");
    }
  }
}
