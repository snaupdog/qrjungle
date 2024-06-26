// ignore_for_file: non_constant_identifier_names
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
    var body = jsonDecode(response.data);

    var hello = body['getCurrentUserDetails'];
    var body2 = jsonDecode(hello);
    var help = body2['data']['items'];
    return help;
   
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

  listFavourites() async {
    var operation = Amplify.API.query(
      request: GraphQLRequest(
        document: '''query ListMyFavourites {
    listMyFavourites
  }''',
      ),
    );

    var response = await operation.response;
    print("ListCustomers error:${response.errors}");
    print("ListCustomers data :${response.data}");
    var body = jsonDecode(response.data);
    print(body);
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

  static const String updateFavouritesMutation = '''
    mutation UpdateFavourites(\$favourites: [String]) {
      updateFavourites(favourites: \$favourites)
    }
  ''';

  addFavourites(List<String> favourites) async {
    var encodedFavourites =
        jsonEncode(favourites); // Encode the favourites list as JSON
    var operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: updateFavouritesMutation,
        variables: {'favourites': encodedFavourites},
      ),
    );
    var response = await operation.response;
    print("add favourites error: ${response.errors}");
    print("add favourites data: ${response.data}");
    var body = jsonDecode(response.data);
  }

  static const String createOrderMutation = '''
  mutation CreateOrder(\$input: createOrderInput) {
    createOrder(input: \$input)
  }
  ''';

  createOrder<String>(String amount, String currency) async {
    // var amount = jsonEncode(damount); // Encode the favourites list as JSON
    // var currency = jsonEncode(dcurrency); // Encode the favourites list as JSON
    var operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: createOrderMutation,
        variables: {
          'input': {
            'amount': amount,
            'currency': currency,
          }
        },
      ),
    );
    var response = await operation.response;
    print("create order  error: ${response.errors}");
    print("create order data  data: ${response.data}");
    var body = jsonDecode(response.data);
    var createOrderJson = jsonDecode(body['createOrder']);
    String orderId = createOrderJson['id'];
    return orderId;
  }

  static const String purchaseOrderMutation = '''
  mutation PuchaseQr(\$input: purchaseQrInput) {
    puchaseQr(input: \$input)
  }
  ''';

  purchaseQr(String qr_code_id, String price, String? utr_no,
      String redirect_url) async {
    // var amount = jsonEncode(damount); // Encode the favourites list as JSON
    // var currency = jsonEncode(dcurrency); // Encode the favourites list as JSON
    print(qr_code_id);
    print(redirect_url);
    print(utr_no);
    print(price);
    var operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: purchaseOrderMutation,
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
    print("purchase   error: ${response.errors}");
    print("purchase   data: ${response.data}");
    var body = jsonDecode(response.data);
    print(body);
  }

  //   print("get ListCustomers body: $body ");
}
