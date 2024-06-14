// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'models/apis.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String qrData = "Press the button to load QR data";

  void _loadQrData() async {
    String data = await Apiss().listAllQrs();
    print("datadone");
    setState(() {
      qrData = data;
    });
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
              onPressed: _loadQrData,
              child: const Text("Load QR Data"),
            ),
          ],
        ),
      ),
    );
  }
}
