// import 'package:flutter/material.dart';
// import 'package:qrjungle/models/apis.dart';
// import 'package:qrjungle/pages/moreqr/moreqr.dart';

// class CategoryCard extends StatefulWidget {
//   final List<String> caturls;
//   final List<String> catobjects;
//   const CategoryCard({super.key, required this.caturls, required this.catobjects});

//   @override
//   State<CategoryCard> createState() => _CategoryCardState();
// }


// class _CategoryCardState extends State<CategoryCard> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 50.0,
//             ),
//             CatCards(urls: widget.caturls, catobjects: widget.catobjects),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CatCards extends StatelessWidget {
//   final List<String> urls;

//   final List<String> catobjects;
//   const CatCards({super.key, required this.urls, required this.catobjects});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 7.0,
//             mainAxisSpacing: 10.0,
//             childAspectRatio: 2 / 3),
//         itemCount: urls.length,
//         itemBuilder: (context, index) {
//           final item = urls[index];
//           final catobject = catobjects[index];
//           return ImageTitleCategoryCard(
//             imageUrl: item,
//             category: catobject, 
//           );
//         },
//       ),
//     );
//   }
// }

// class ImageTitleCategoryCard extends StatelessWidget {
//   final String imageUrl;
//   final String category;

//   const ImageTitleCategoryCard({
//     super.key,
//     required this.imageUrl,
//     required this.category,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Brightness _brightness = Theme.of(context).brightness;
//     TextTheme _textTheme = Theme.of(context).textTheme;
//     Color colorcolor = _brightness == Brightness.dark ? Color(0xff1B1B1B) : Color.fromARGB(255, 247, 249, 254);
//     return GestureDetector(
//       //onTap: () {        },
//       child: Container(
//         color: Colors.transparent,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(15.0),
//           child: Card(
//             color: colorcolor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15.0),
//             ),
//             elevation: 5,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(15.0),
//                     topRight: Radius.circular(15.0),
//                   ),
//                   child: Image.asset(
//                     ''
//                   ),
//                   // child: CachedNetworkImage(
//                   //   imageUrl: imageUrl,
//                   //   fit: BoxFit.cover,
//                   //   placeholder: (context, url) =>
//                   //       const Center(child: CircularProgressIndicator()),
//                   //   errorWidget: (context, url, error) =>
//                   //       const Icon(Icons.error),
//                   // ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
//                       child: Text(
//                         category,
//                         style: _textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }