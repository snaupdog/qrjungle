// ignore_for_file: unused_local_variable, non_constant_identifier_names
import 'dart:convert';
import 'package:http/http.dart';

import 'package:amplify_flutter/amplify_flutter.dart';

class Apiss {
  static String preurl =
      "https://qrjungle-all-qrcodes.s3.ap-south-1.amazonaws.com/";
  static List mycatlist = [];
  static List myallqrslist = [];
  static List myfavslist = [];
  static List myqrslist = [];
  static List customcategorielist = [];
  static List catageroylist = [];
  static List<String> favqrsids = [];
  static List userdetailslist = [];
  static String qr_idpayment = "";
  static String qr_redirecturl = "";

  // Future clearlist() async {
  //   qrinfolist = [];
  // }

  Future getQrFromId(String qr_code_id) async {
    final Map<String, String> data = {
      "command": "getQRCodeDetails",
      "qr_code_id": qr_code_id,
    };
    final jsonData = json.encode(data);
    final response = await post(
      Uri.parse(
          'https://ppq54dc20b.execute-api.ap-south-1.amazonaws.com/production/get_qr_code_details'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );
  }

  Future getCategories() async {
    print("calling get Categories");
    final Map<String, String> data = {
      "command": "listActiveCategories",
      "nextToken": ""
    };
    final jsonData = json.encode(data);
    final response = await post(
      Uri.parse(
          'https://ppq54dc20b.execute-api.ap-south-1.amazonaws.com/production/list_available_categories'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      catageroylist = body['data'];
    } else {
      print(response.body);
      throw Exception('Failed to load categories');
    }
  }

  getqrfromCategories(String categoryName) async {
    print("calling get qr from catagories");
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
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      var qrlist = body['data'];
      mycatlist = qrlist;
    } else {
      print(response.body);
      throw Exception("failed to get qr from catagorie $categoryName ");
    }
  }

  getAllqrs(String nextToken) async {
    print("callig get all qrs");
    final Map<String, String> data = {
      "command": "listPortalQrs",
      "nextToken": nextToken
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
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  getcustomcategories() async {
    print("custom categories");
    var operation = Amplify.API.query(
      request: GraphQLRequest(
        document: '''query ListMyPrivateCategories {
    listMyPrivateCategories
  }''',
      ),
    );

    try {
      var response = await operation.response;
      var body = jsonDecode(response.data);
      var x = jsonDecode(body['listMyPrivateCategories']);
      customcategorielist = x['data'];
    } catch (e) {
      print("error: $e");
    }
  }

  listFavourites() async {
    print("calling lsit my  favourites");
    var operation = Amplify.API.query(
      request: GraphQLRequest(
        document: '''query ListMyFavourites {
    listMyFavourites
  }''',
      ),
    );

    try {
      var response = await operation.response;
      var body = jsonDecode(response.data);
      var hello = body['listMyFavourites'];
      var body2 = jsonDecode(hello);
      myfavslist = body2['data'] as List;
      favqrsids =
          myfavslist.map((item) => item['qr_code_id'].toString()).toList();
    } catch (e) {
      print("error: $e");
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

  updateRedeemables(String count) async {
    print("calling update redeemables with count - $count");
    var operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: ''' mutation UpdateRedeemable(\$redeem_count: String) {
    updateRedeemable(redeem_count: \$redeem_count)}''',
        variables: {'redeem_count': count},
      ),
    );

    var response = await operation.response;
    print(response);
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

  addFavourites(List<String> favourited) async {
    print("calling addfavourties");
    var encodedFavourites =
        jsonEncode(favourited); // Encode the favourites list as JSON
    var operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: '''
    mutation UpdateFavourites(\$favourites: [String]) {
      updateFavourites(favourites: \$favourites)
    }
  ''',
        variables: {'favourites': encodedFavourites},
      ),
    );
    var response = await operation.response;
    var body = jsonDecode(response.data);
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

  requestCustom(String phno, String details) async {
    var operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: '''
mutation RequestCustomization(\$user_phone_number: String!, \$details: String) {
  requestCustomization(
    user_phone_number: \$user_phone_number
    details: \$details
  )
}
''',
        //     variables: {
        //       'user_phone_number': phno,
        //       'details': details,
        //     },
        //   ),
        // );
        variables: {
          'user_phone_number': phno,
          'details': details,
        },
      ),
    );
    var response = await operation.response;
    var body = jsonDecode(response.data);
    var requestCustomQR = jsonDecode(body['requestCustomization']);
    print(requestCustomQR);
    print('CODE YAY${requestCustomQR['status']}');
    return requestCustomQR['status'];
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
            'utr_no': utr_no,
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
