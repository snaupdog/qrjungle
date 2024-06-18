// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'models/apis.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              size: 30,
              Icons.home,
              color: Color(0xff969a2f),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: const SingleChildScrollView(
        // Wrap in SingleChildScrollView for scrolling capability
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "BLAH BLHA BLAH",
                style: TextStyle(color: Color(0xff969a2f), fontSize: 30.0),
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: QrcodeCards(),
            ),
          ],
        ),
      ),
    );
  }
}

class QrcodeCards extends StatelessWidget {
  const QrcodeCards({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap:
          true, // Ensure GridView is scrollable within SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(), //
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            3, // Number of columns (you can change this to 1 if you want larger cards)
        crossAxisSpacing: 10.0, // Horizontal spacing between items
        mainAxisSpacing: 10.0,
      ),
      itemCount: qrdata.length,
      itemBuilder: (context, index) {
        final item = qrdata[index];

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              HeroDialogRoute(
                builder: (context) => Center(
                  child: PopupCard(item: item),
                ),
              ),
            );
          },
          child: Hero(
            tag: item,
            child: Container(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    15.0), // Rounded corners for the image
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
