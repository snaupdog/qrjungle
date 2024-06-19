import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class PopupCard extends StatelessWidget {
  final String item;
  const PopupCard({super.key, required this.item});

  Future<Color> getMostProminentColor(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load image');
    }

    final bytes = response.bodyBytes;
    final image = img.decodeImage(Uint8List.fromList(bytes));
    if (image == null) throw Exception('Image cannot be decoded');

    final Map<int, int> colorCount = {};
    for (var y = 0; y < image.height; y = y + 200) {
      for (var x = 0; x < image.width; x = x + 200) {
        final pixel = image.getPixel(x, y);
        final color = ((pixel.a.toInt() & 0xFF) << 24) |
            ((pixel.r.toInt() & 0xFF) << 16) |
            ((pixel.g.toInt() & 0xFF) << 8) |
            (pixel.b.toInt() & 0xFF);
        colorCount[color] = (colorCount[color] ?? 0) + 1;
      }
    }

    final mostProminentColor =
        colorCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    return Color(mostProminentColor);
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: item,
      child: FutureBuilder<Color>(
        future: getMostProminentColor(item),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading image'));
          } else if (snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0.0, 0.7, 1.0],
                  colors: [
                    // Colors.black.withOpacity(0.7),
                    Colors.black87,
                    snapshot.data!.withOpacity(0.3),
                    snapshot.data!,
                  ],
                ),
              ),
              width: 400,
              height: 600,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: CachedNetworkImage(
                          imageUrl: item,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Text(
                      "Cost : -100\$",
                      style: TextStyle(color: Colors.white, fontSize: 45.0),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No color found'));
          }
        },
      ),
    );
  }
}
