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
    print(body);
  }

  //   print("get ListCustomers body: $body ");
}
