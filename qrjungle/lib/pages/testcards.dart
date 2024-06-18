import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'hero_dialog.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10.0,
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
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: QrcodeCards(urls: widget.urls),
            ),
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: urls.length,
      itemBuilder: (context, index) {
        final item = urls[index];

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
                borderRadius: BorderRadius.circular(15.0),
                child: CachedNetworkImage(
                  imageUrl: item,
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
  final String item;
  const PopupCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: item,
      child: Container(
        color: Colors.transparent,
        width: 350,
        height: 400,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CachedNetworkImage(
                  imageUrl: item,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const Expanded(
              flex: 1,
              child: Text(
                "Cost : -100\$\$",
                style: TextStyle(color: Colors.white, fontSize: 45.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
