import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/models/apis.dart';
import 'package:qrjungle/pages/moreqr/moreqr.dart';

class Test extends StatefulWidget {
  final List<String> urls;
  final List<QrInfo> qrobjects;
  const Test({super.key, required this.urls, required this.qrobjects});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50.0,
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "BLAH BLHA BLAH",
                style: TextStyle(color: Color(0xff969a2f), fontSize: 30.0),
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            QrcodeCards(urls: widget.urls, qrobjects: widget.qrobjects),
          ],
        ),
      ),
    );
  }
}

class QrcodeCards extends StatelessWidget {
  final List<String> urls;

  final List<QrInfo> qrobjects;
  const QrcodeCards({super.key, required this.urls, required this.qrobjects});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 7.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 2 / 3),
        itemCount: urls.length,
        itemBuilder: (context, index) {
          final item = urls[index];
          final suckonthi = qrobjects[index];
          return ImageTitleCategoryCard(
            imageUrl: item,
            qr_code_id: suckonthi.qr_code_id, // Replace with your actual title
            category: suckonthi.category, // Replace with your actual category
            price: suckonthi.price, // Replace with your actual category
          );
        },
      ),
    );
  }
}

class ImageTitleCategoryCard extends StatelessWidget {
  final String imageUrl;
  final String qr_code_id;
  final String category;
  final String? price;

  const ImageTitleCategoryCard({
    super.key,
    required this.imageUrl,
    required this.qr_code_id,
    required this.category,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MoreQr(imageUrl: imageUrl)),
        );
      },
      child: Container(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Card(
            color: const Color(0xff1B1B1B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      qr_code_id,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
