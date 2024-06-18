// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'models/apis.dart';
import 'pages/testcards.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    fetchUrls();
  }

  String qrData = "Press the button to load QR data";
  List<String> keys = [
    "pJRx.png",
    "ga3e.png",
    "ApGl.png",
    "2KzT.png",
    "2qap.png",
    "xxNM.png",
    "UAz8.png",
    "pJbs.png",
    "SuNB.png",
    "imXo.png",
    "HPnW.png",
    "3gS7.png",
    "xmN2.png",
    "CmfG.png",
    "YKVr.png",
    "QpQ8.png",
    "afJG.png",
    "iYRb.png",
    "g444.png",
    "6dYD.png",
    "UfNb.png",
    "ghEt.png",
    "6po3.png",
    "AN2I.png",
    "azRX.png",
    "pNcj.png",
    "ZRQH.png",
    "Wjuv.png",
    "JM9r.png",
    "wikG.png",
    "iDUZ.png",
    "9UxM.png",
    "Trme.png",
    "V8Bj.png",
    "lhYE.png",
    "r3fW.png",
    "W5Ks.png",
    "4eQV.png",
    "bY5B.png",
    "LdBv.png",
    "3zDa.png",
    "DOPZ.png",
    "K1M8.png",
    "2Omp.png",
    "xoyP.png",
    "7JEu.png",
    "AIfi.png",
    "Md4r.png"
  ];
  List<String> urls = [];
  bool isLoading = true;

  Future<void> fetchUrls() async {
    try {
      final fetchedUrls = await Future.wait(
          keys.map((key) => Apiss().getPresignedUrl(key)).toList());
      print(fetchedUrls);
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
