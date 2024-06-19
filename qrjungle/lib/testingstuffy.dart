import 'package:flutter/material.dart';
import 'package:qrjungle/pages/testcards.dart';

// class Testingstuffy extends StatelessWidget {
//   const Testingstuffy({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Helo"),
//       ),
//       body: Text("Hello"),
//     );
//   }
// }

class Testingstuffy extends StatelessWidget {
  const Testingstuffy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xff121212),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Image, Title, and Category Widget'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 300,
                    child: ImageTitleCategoryCard(
                      imageUrl:
                          'https://images.unsplash.com/photo-1450849608880-6f787542c88a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8M3x8fGVufDB8fHx8fA%3D%3D', // Replace with your image URL
                      title: 'Sample Title',
                      category: 'Sample Category',
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 300,
                    child: ImageTitleCategoryCard(
                      imageUrl:
                          'https://images.unsplash.com/photo-1499988921418-b7df40ff03f9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTV8fHxlbnwwfHx8fHw%3D', // Replace with your image URL
                      title: 'Sample Title',
                      category: 'Sample Category',
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 300,
                    child: ImageTitleCategoryCard(
                      imageUrl:
                          'https://images.unsplash.com/photo-1469521669194-babb45599def?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8OHx8fGVufDB8fHx8fA%3D%3D', // Replace with your image URL
                      title: 'Sample Title',
                      category: 'Sample Category',
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 300,
                    child: ImageTitleCategoryCard(
                      imageUrl:
                          'https://images.unsplash.com/photo-1444090542259-0af8fa96557e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8Nnx8fGVufDB8fHx8fA%3D%3D', // Replace with your image URL
                      title: 'Sample Title',
                      category: 'Sample Category',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageTitleCategoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;

  ImageTitleCategoryCard({
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
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
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
          ),
        ],
      ),
    );
  }
}
