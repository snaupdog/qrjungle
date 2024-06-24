import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart';
import 'qr_info.dart';

class ApissRest {
  listQrCategories(var next) async {
    final url = Uri.parse(
        'https://hciu6m7wcj.execute-api.ap-south-1.amazonaws.com/prod/list_categories');

    final response = await post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'command': 'listCategories',
          if (next != "") 'nextToken': next,
        }));

    var body = json.decode(response.body);
    log("ListAllQrs: $body");
    return body;
  }

  Future getCategories() async {
    final Map<String, String> data = {"command": "listActiveCategories"};
    final jsonData = json.encode(data);
    final response = await post(
      Uri.parse(
          'https://ppq54dc20b.execute-api.ap-south-1.amazonaws.com/production/list_available_categories'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );
    // print(response.body);
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

  Future<List<QrInfo>> getqrfromCategories(String categoryName) async {
    final Map<String, String> data = {
      "command": "listQrByCategory",
      "qr_code_category_name": categoryName,
    };
    List<QrInfo> allqrinfo = [];
    final jsonData = json.encode(data);
    final response = await post(
      Uri.parse(
          'https://hciu6m7wcj.execute-api.ap-south-1.amazonaws.com/prod/list_qr_by_category'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );
    final dataa = json.decode(response.body);

    print(dataa['nextToken']);
    final x = dataa['data'];

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
}
