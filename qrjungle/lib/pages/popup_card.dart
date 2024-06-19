import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PopupCard extends StatelessWidget {
  final String item;
  const PopupCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: item,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              // Colors.black,
              Color(0xff3B95BA),
              Color(0xff443068),
            ],
          ),
        ),
        // color: Colors.red,
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
