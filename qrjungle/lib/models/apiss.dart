// ignore_for_file: unused_local_variable, non_constant_identifier_names
import 'dart:convert';
import 'package:http/http.dart';

import 'package:amplify_flutter/amplify_flutter.dart';

class Apiss {
  static List mycatlist = [];
  static List myallqrslist = [];
  static List myfavslist = [];
  static List myqrslist = [];
  static List catageroylist = [];

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
    final Map<String, String> data = {"command": "listActiveCategories"};
    final jsonData = json.encode(data);
    final response = await post(
      Uri.parse(
          'https://ppq54dc20b.execute-api.ap-south-1.amazonaws.com/production/list_available_categories'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      catageroylist = body;
    } else {
      print(response.body);
      throw Exception('Failed to load categories');
    }
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
      print(response.body);
      throw Exception('Failed to fetch URL for key $key');
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
      "command": "listAllQrs",
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

  listFavourites() async {
    print("calling lsit my  favourites");
    var operation = Amplify.API.query(
      request: GraphQLRequest(
        document: '''query ListMyFavourites {
    listMyFavourites
  }''',
      ),
    );

    var response = await operation.response;

    var body = jsonDecode(response.data);
    var hello = body['listMyFavourites'];
    var body2 = jsonDecode(hello);
    myfavslist = body2['data'].toList();
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
    var help = body2['data']['items'];

    return help;
  }

  addFavourites(List<String> favourited) async {
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
