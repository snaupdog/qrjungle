// ignore_for_file: unused_local_variable

import 'package:amplify_flutter/amplify_flutter.dart';

import 'dart:convert';

class ApissGraph {
  listCustomers() async {
    var operation = Amplify.API.query(
        request: GraphQLRequest(document: '''query GetCurrentUserDetails {
    getCurrentUserDetails
  }'''));

    var response = await operation.response;
    print("ListCustomers error:${response.errors}");
    print("ListCustomers data :${response.data}");
    var body = jsonDecode(response.data);
    //   print("get ListCustomers body: $body ");
    //   if (jsonDecode(body['listCustomers'])['status'] == "SUCCESS") {
    //     return jsonDecode(body['listCustomers'])['data'];
    //   } else {
    //     return "Error";
    //   }
    // } catch (e) {
    //   print("listcustomers error :$e");
    //   return "Error";
    // }
  }
}
