// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'models/apis.dart';
import 'package:http/http.dart';
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String qrData = "Press the button to load QR data";

  getqr() async {
    final Map<String, String> data = {
      // "command": "listCategories",
      // "next_token": ""

      "command": "getPresignedURL",
      "key": "ZRQH.png"
    };
    final jsonData = json.encode(data);
    final response = await post(
      // Uri.parse('http://localhost:8080/data'),
      // Uri.parse(
      //     'https://hciu6m7wcj.execute-api.ap-south-1.amazonaws.com/prod/list_categories'),
      Uri.parse(
          'https://ppq54dc20b.execute-api.ap-south-1.amazonaws.com/production/get_presigned_url'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );

    print(response.statusCode);
    print(response.body);
    final dataa = json.decode(response.body);
    print(dataa['url']);

    // if (response.body == "201") {
    //   print('sigup  created successfully!');
    // } else {
    //   print('Failed to create sigup.');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Data"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              qrData,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // String nextToken =
                //     "your-next-token-value"; // Replace with actual token value
                getqr();
              },
              child: const Text("Load QR Data"),
            ),
          ],
        ),
      ),
    );
  }
}
