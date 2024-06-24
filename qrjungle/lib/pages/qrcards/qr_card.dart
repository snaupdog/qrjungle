// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../../models/apis.dart';
import 'widgets/testcards.dart';
bool isLoading = true;
class qrCards extends StatefulWidget {
  const qrCards({super.key});

  @override
  _qrCardsState createState() => _qrCardsState();
}

class _qrCardsState extends State<qrCards> {
  List<QrInfo> qrobjects = []; // Declare qrobjects here
  String qrData = "Press the button to load QR data";
  List<String> urls = [];
  String token = '';
  

  @override
  void initState() {
    super.initState();
    fetchUrls();
  }

  Future<void> fetchUrls() async {
    try {
      qrobjects = await Apiss().getAllqrs(token);
      final fetchedUrls = await Future.wait(
          qrobjects.map((key) => Apiss().getPresignedUrl(key.UrlKey)).toList());
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
      body: 
      //isLoading
         // ? Center(child: CircularProgressIndicator())
           QRCard(
              urls: urls,
              qrobjects: qrobjects,
            ),
    );
  }
}
