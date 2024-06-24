// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/apis.dart';
import '../moreqr/moreqr.dart';

class QrCards extends StatefulWidget {
  const QrCards({super.key});

  @override
  QrCardsState createState() => QrCardsState();
}

class QrCardsState extends State<QrCards> {
  List<QrInfo> qrobjects = []; // Declare qrobjects here
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
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    TextTheme textTheme = Theme.of(context).textTheme;
    Color colorcolor = brightness == Brightness.dark
        ? const Color(0xff1B1B1B)
        : const Color.fromARGB(255, 247, 249, 254);
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
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
              final imageUrl = urls[index];
              final item = qrobjects[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MoreQr(imageUrl: imageUrl)),
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
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
                                child: Text(item.qr_code_id,
                                    style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Text(item.category,
                                    style: textTheme.bodySmall),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
