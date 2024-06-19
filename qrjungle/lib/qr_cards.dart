// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'models/apis.dart';
import 'pages/testcards.dart';

class qrCards extends StatefulWidget {
  const qrCards({super.key});

  @override
  _qrCardsState createState() => _qrCardsState();
}

class _qrCardsState extends State<qrCards> {
  @override
  void initState() {
    super.initState();
    fetchUrls();
  }

  String qrData = "Press the button to load QR data";
  List<String> urls = [];
  String token = '';
  bool isLoading = true;

  Future<void> fetchUrls() async {
    try {
      List<String> keys = await Apiss().getAllqrs(token);
      final fetchedUrls = await Future.wait(
          keys.map((key) => Apiss().getPresignedUrl(key)).toList());
      // print(fetchedUrls);
      setState(() {
        urls = fetchedUrls;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Test(
        urls: urls,
      ),
    );
  }
}
