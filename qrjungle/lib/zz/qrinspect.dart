import 'package:flutter/material.dart';

class QRView extends StatefulWidget {
final url;
  const QRView(this.url);

  @override
  State<QRView> createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {
  @override
  void initState() {
    print("obj: ${widget.url}");
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QRInspect'),
      ),
      body: Center(
        child: Container(
          child: Image.network(widget.url['image_url']),
          ),
      ),
    );
  }
}