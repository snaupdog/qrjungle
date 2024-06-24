import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/models/apis.dart';
import 'package:qrjungle/pages/moreqr/moreqr.dart';
import 'package:qrjungle/pages/qrcards/qr_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QRCard extends StatefulWidget {
  final List<String> urls;
  final List<QrInfo> qrobjects;
  const QRCard({super.key, required this.urls, required this.qrobjects});

  @override
  State<QRCard> createState() => _QRCardState();
}

class _QRCardState extends State<QRCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50.0,
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
            qr_code_id: suckonthi.qr_code_id,
            category: suckonthi.category, 
            price: suckonthi.price,
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
    Brightness _brightness = Theme.of(context).brightness;
    TextTheme _textTheme = Theme.of(context).textTheme;
    Color colorcolor = _brightness == Brightness.dark ? Color(0xff1B1B1B) : Color.fromARGB(255, 247, 249, 254);
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
            shadowColor: Colors.white,
            
            color: colorcolor,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
                      child: Text(
                        qr_code_id,
                        style: _textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Text(
                        category,
                        style: _textTheme.bodySmall
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
