import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:typed_data';

Future<Color> getMostProminentColor(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode != 200) {
    throw Exception('Failed to load image');
  }

  final bytes = response.bodyBytes;
  final image = img.decodeImage(Uint8List.fromList(bytes));
  if (image == null) throw Exception('Image cannot be decoded');

  final Map<int, int> colorCount = {};
  int hi = 0;
  final x = image.getPixel(500, 400);
  print(x.runtimeType);
  print(x.a);
  print(x.r);
  print(x.b);
  print(x.g);
  print("*****----");
  print(x.r.toInt());
  print(x.r.toInt() & 0xFF);

  print("*****----");
  print((x.a.toInt() & 0xFF) << 24);
  print((x.r.toInt() & 0xFF) << 16);
  print((x.g.toInt() & 0xFF) << 8);
  print(x.b.toInt() & 0xFF);
  print("******-------------------------******");

  for (var y = 0; y < image.height; y = y + 200) {
    for (var x = 0; x < image.width; x = x + 200) {
      final pixel = image.getPixel(x, y);
      final color = ((pixel.a.toInt() & 0xFF) << 24) |
          ((pixel.r.toInt() & 0xFF) << 16) |
          ((pixel.g.toInt() & 0xFF) << 8) |
          (pixel.b.toInt() & 0xFF);
      colorCount[color] = (colorCount[color] ?? 0) + 1;
      hi++;
    }
  }
  print(hi);
  print(colorCount);

  final mostProminentColor =
      colorCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  return Color(mostProminentColor);
}

class GradientBackground extends StatelessWidget {
  final Color color;

  const GradientBackground({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

class GradientTest extends StatelessWidget {
  const GradientTest({super.key});

  @override
  Widget build(BuildContext context) {
    const String imageUrl =
        'https://images.unsplash.com/photo-1500042600524-37ecb686c775?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'; // Replace with your image URL

    return Scaffold(
      appBar: AppBar(
        title: Text("Hradoemt"),
      ),
      body: FutureBuilder<Color>(
        future: getMostProminentColor(imageUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading image'));
          } else if (snapshot.hasData) {
            return GradientBackground(color: snapshot.data!);
          } else {
            return const Center(child: Text('No color found'));
          }
        },
      ),
    );
  }
}
