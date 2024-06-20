import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  final List<String> urls;
  const Test({super.key, required this.urls});

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
            QrcodeCards(urls: widget.urls),
          ],
        ),
      ),
    );
  }
}

class QrcodeCards extends StatelessWidget {
  final List<String> urls;
  const QrcodeCards({super.key, required this.urls});

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

          return Container(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: ImageTitleCategoryCard(
                imageUrl: item,
                title: 'Sample Title', // Replace with your actual title
                category:
                    'Sample Category', // Replace with your actual category
              ),
            ),
          );
        },
      ),
    );
  }
}

class ImageTitleCategoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;

  const ImageTitleCategoryCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
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
    );
  }
}
