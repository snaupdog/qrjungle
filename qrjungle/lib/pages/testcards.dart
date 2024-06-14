import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'data.dart';
import 'hero_dialog.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
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
              color: Colors.green,
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

class PopupCard extends StatelessWidget {
  final Bruv item;
  const PopupCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: item,
      child: Container(
        color: Colors.transparent,
        child: SizedBox(
          width: 500,
          height: 400,
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      15.0), // Rounded corners for the image
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover, // Ensures the image covers the card
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Cost : - ${item.price}\$\$",
                  style: const TextStyle(color: Colors.white, fontSize: 45.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
